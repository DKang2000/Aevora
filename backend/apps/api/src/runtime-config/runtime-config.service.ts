import { BadRequestException, Injectable, InternalServerErrorException } from "@nestjs/common";
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

type RuntimeConfigPayload = {
  schemaVersion: string;
  featureFlags: Record<string, unknown>;
  economy: Record<string, unknown>;
  onboarding: Record<string, unknown>;
  paywall: Record<string, unknown>;
  reminders: Record<string, unknown>;
  widgets: Record<string, unknown>;
  liveActivities: Record<string, unknown>;
  chapterGating: Record<string, unknown>;
};

type RuntimeConfigReleaseRecord = {
  id: string;
  label: string;
  sourcePath: string;
  schemaVersion: string;
  etag: string;
  promotedAt: string;
  promotedBy: string;
  notes?: string | null;
};

type RuntimeConfigReleaseState = {
  activeReleaseId: string | null;
  history: RuntimeConfigReleaseRecord[];
};

@Injectable()
export class RuntimeConfigService {
  private readonly repoRoot = path.resolve(__dirname, "../../../../../");
  private readonly defaultPath = path.resolve(
    this.repoRoot,
    "shared/contracts/remote-config/defaults/launch-defaults.v1.json"
  );
  private readonly statePath = process.env.AEVORA_REMOTE_CONFIG_STATE_PATH
    ? path.resolve(process.env.AEVORA_REMOTE_CONFIG_STATE_PATH)
    : path.join(tmpdir(), "aevora-runtime-config-release-state.json");

  getConfig(): { etag: string; payload: RuntimeConfigPayload; source: string } {
    const state = this.loadState();
    const promotedRelease = state.history.find((entry) => entry.id === state.activeReleaseId) ?? null;
    const overridePath = process.env.AEVORA_REMOTE_CONFIG_OVERRIDE_PATH;
    const fallbackPayload = this.readAndValidate(this.defaultPath);

    if (!overridePath) {
      if (!promotedRelease) {
        return {
          etag: this.createEtag(fallbackPayload),
          payload: fallbackPayload,
          source: "default"
        };
      }

      try {
        const promotedPayload = this.readAndValidate(promotedRelease.sourcePath);
        return {
          etag: this.createEtag(promotedPayload),
          payload: promotedPayload,
          source: "promoted_override"
        };
      } catch {
        return {
          etag: this.createEtag(fallbackPayload),
          payload: fallbackPayload,
          source: "fallback_after_invalid_promoted_override"
        };
      }
    }

    try {
      const overridePayload = this.readAndValidate(overridePath);
      return {
        etag: this.createEtag(overridePayload),
        payload: overridePayload,
        source: "override"
      };
    } catch {
      return {
        etag: this.createEtag(fallbackPayload),
        payload: fallbackPayload,
        source: "fallback_after_invalid_override"
      };
    }
  }

  getReleaseStatus(): Record<string, unknown> {
    const state = this.loadState();
    const activeRelease = state.history.find((entry) => entry.id === state.activeReleaseId) ?? null;

    return {
      defaultPath: this.defaultPath,
      envOverridePath: process.env.AEVORA_REMOTE_CONFIG_OVERRIDE_PATH ?? null,
      activeRelease,
      history: state.history
    };
  }

  promoteRelease(input: {
    candidatePath: string;
    label: string;
    promotedBy: string;
    notes?: string;
  }): { release: RuntimeConfigReleaseRecord; activeRelease: RuntimeConfigReleaseRecord } {
    const targetPath = this.resolveRepoPath(input.candidatePath);
    const payload = this.readAndValidate(targetPath);
    const state = this.loadState();
    const release: RuntimeConfigReleaseRecord = {
      id: `rcr_${this.createEtag(`${targetPath}:${Date.now()}:${input.label}`).slice(0, 12)}`,
      label: input.label,
      sourcePath: targetPath,
      schemaVersion: payload.schemaVersion,
      etag: this.createEtag(payload),
      promotedAt: new Date().toISOString(),
      promotedBy: input.promotedBy,
      notes: input.notes ?? null
    };

    const nextState: RuntimeConfigReleaseState = {
      activeReleaseId: release.id,
      history: [release, ...state.history].slice(0, 20)
    };

    this.saveState(nextState);
    return {
      release,
      activeRelease: release
    };
  }

  private readAndValidate(targetPath: string): RuntimeConfigPayload {
    if (!existsSync(targetPath)) {
      throw new InternalServerErrorException(`Runtime config not found at ${targetPath}.`);
    }

    const payload = JSON.parse(readFileSync(targetPath, "utf8")) as Partial<RuntimeConfigPayload>;
    const requiredKeys: Array<keyof RuntimeConfigPayload> = [
      "schemaVersion",
      "featureFlags",
      "economy",
      "onboarding",
      "paywall",
      "reminders",
      "widgets",
      "liveActivities",
      "chapterGating"
    ];

    for (const key of requiredKeys) {
      if (!(key in payload)) {
        throw new InternalServerErrorException(`Missing runtime-config key: ${key}`);
      }
    }

    return payload as RuntimeConfigPayload;
  }

  private createEtag(payload: unknown): string {
    return createHash("sha256").update(JSON.stringify(payload)).digest("hex");
  }

  private resolveRepoPath(candidatePath: string): string {
    if (!candidatePath.trim()) {
      throw new BadRequestException("Candidate path is required.");
    }

    const resolved = path.isAbsolute(candidatePath)
      ? path.resolve(candidatePath)
      : path.resolve(this.repoRoot, candidatePath);

    if (!resolved.startsWith(`${this.repoRoot}${path.sep}`) && resolved !== this.defaultPath) {
      throw new BadRequestException("Candidate path must stay within the repo.");
    }

    return resolved;
  }

  private loadState(): RuntimeConfigReleaseState {
    if (!existsSync(this.statePath)) {
      return {
        activeReleaseId: null,
        history: []
      };
    }

    const parsed = JSON.parse(readFileSync(this.statePath, "utf8")) as Partial<RuntimeConfigReleaseState>;
    return {
      activeReleaseId: parsed.activeReleaseId ?? null,
      history: Array.isArray(parsed.history) ? parsed.history : []
    };
  }

  private saveState(state: RuntimeConfigReleaseState): void {
    mkdirSync(path.dirname(this.statePath), { recursive: true });
    writeFileSync(this.statePath, JSON.stringify(state, null, 2));
  }
}
