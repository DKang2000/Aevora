import { BadRequestException, ConflictException, Injectable, InternalServerErrorException } from "@nestjs/common";
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

type ContentPayload = Record<string, unknown> & {
  schemaVersion: string;
};

type CopyPayload = {
  schemaVersion?: string;
};

type ContentReleaseRecord = {
  id: string;
  label: string;
  contentPath: string;
  copyPath: string;
  contentVersion: string;
  copyVersion: string;
  etag: string;
  promotedAt: string;
  promotedBy: string;
  notes?: string | null;
};

type ContentReleaseState = {
  activeReleaseId: string | null;
  history: ContentReleaseRecord[];
};

@Injectable()
export class ContentService {
  private readonly repoRoot = path.resolve(__dirname, "../../../../../");
  private readonly contentPath = path.resolve(this.repoRoot, "content/launch/launch-content.min.v1.json");
  private readonly copyPath = path.resolve(this.repoRoot, "content/launch/copy/en/core.v1.json");
  private readonly statePath = process.env.AEVORA_CONTENT_STATE_PATH
    ? path.resolve(process.env.AEVORA_CONTENT_STATE_PATH)
    : path.join(tmpdir(), "aevora-content-release-state.json");

  getManifest(): Record<string, unknown> {
    const { contentPath, copyPath, source } = this.resolveActivePaths();
    const content = this.readAndValidate(contentPath);
    const copy = this.readJson(copyPath);

    return {
      contentVersion: content.schemaVersion,
      copyVersion: (copy as { schemaVersion?: string }).schemaVersion ?? "v1",
      etag: this.createEtag({ content, copy }),
      source
    };
  }

  getBootstrap(requestedVersion?: string): Record<string, unknown> {
    const { contentPath, copyPath } = this.resolveActivePaths();
    const content = this.readAndValidate(contentPath);
    const copy = this.readJson(copyPath);

    if (requestedVersion && requestedVersion !== content.schemaVersion) {
      throw new ConflictException("Requested content version does not match current launch content.");
    }

    return {
      manifest: this.getManifest(),
      content,
      copy
    };
  }

  getReleaseStatus(): Record<string, unknown> {
    const state = this.loadState();
    const activeRelease = state.history.find((entry) => entry.id === state.activeReleaseId) ?? null;

    return {
      defaultContentPath: this.contentPath,
      defaultCopyPath: this.copyPath,
      envOverridePath: process.env.AEVORA_CONTENT_OVERRIDE_PATH ?? null,
      envCopyOverridePath: process.env.AEVORA_COPY_OVERRIDE_PATH ?? null,
      activeRelease,
      history: state.history
    };
  }

  promoteRelease(input: {
    contentPath: string;
    copyPath?: string;
    label: string;
    promotedBy: string;
    notes?: string;
  }): { release: ContentReleaseRecord; activeRelease: ContentReleaseRecord } {
    const nextContentPath = this.resolveRepoPath(input.contentPath);
    const nextCopyPath = input.copyPath ? this.resolveRepoPath(input.copyPath) : this.copyPath;
    const content = this.readAndValidate(nextContentPath);
    const copy = this.readJson(nextCopyPath) as CopyPayload;
    const state = this.loadState();
    const release: ContentReleaseRecord = {
      id: `ctr_${this.createEtag(`${nextContentPath}:${nextCopyPath}:${Date.now()}:${input.label}`).slice(0, 12)}`,
      label: input.label,
      contentPath: nextContentPath,
      copyPath: nextCopyPath,
      contentVersion: content.schemaVersion,
      copyVersion: copy.schemaVersion ?? "v1",
      etag: this.createEtag({ content, copy }),
      promotedAt: new Date().toISOString(),
      promotedBy: input.promotedBy,
      notes: input.notes ?? null
    };

    const nextState: ContentReleaseState = {
      activeReleaseId: release.id,
      history: [release, ...state.history].slice(0, 20)
    };

    this.saveState(nextState);
    return {
      release,
      activeRelease: release
    };
  }

  private readAndValidate(targetPath: string): ContentPayload {
    const payload = this.readJson(targetPath) as Partial<ContentPayload>;

    if (!payload.schemaVersion || !Array.isArray(payload.originFamilies) || !Array.isArray(payload.identityShells)) {
      throw new InternalServerErrorException("Invalid content payload.");
    }

    return payload as ContentPayload;
  }

  private readJson(targetPath: string): unknown {
    if (!existsSync(targetPath)) {
      throw new InternalServerErrorException(`Content file not found at ${targetPath}.`);
    }

    return JSON.parse(readFileSync(targetPath, "utf8"));
  }

  private createEtag(payload: unknown): string {
    return createHash("sha256").update(JSON.stringify(payload)).digest("hex");
  }

  private resolveActivePaths(): { contentPath: string; copyPath: string; source: string } {
    const envContentPath = process.env.AEVORA_CONTENT_OVERRIDE_PATH;
    const envCopyPath = process.env.AEVORA_COPY_OVERRIDE_PATH;

    if (envContentPath || envCopyPath) {
      return {
        contentPath: envContentPath ?? this.contentPath,
        copyPath: envCopyPath ?? this.copyPath,
        source: "env_override"
      };
    }

    const state = this.loadState();
    const activeRelease = state.history.find((entry) => entry.id === state.activeReleaseId) ?? null;
    if (activeRelease) {
      return {
        contentPath: activeRelease.contentPath,
        copyPath: activeRelease.copyPath,
        source: "promoted_override"
      };
    }

    return {
      contentPath: this.contentPath,
      copyPath: this.copyPath,
      source: "default"
    };
  }

  private resolveRepoPath(candidatePath: string): string {
    if (!candidatePath.trim()) {
      throw new BadRequestException("Candidate path is required.");
    }

    const resolved = path.isAbsolute(candidatePath)
      ? path.resolve(candidatePath)
      : path.resolve(this.repoRoot, candidatePath);

    if (!resolved.startsWith(`${this.repoRoot}${path.sep}`) && resolved !== this.contentPath && resolved !== this.copyPath) {
      throw new BadRequestException("Candidate path must stay within the repo.");
    }

    return resolved;
  }

  private loadState(): ContentReleaseState {
    if (!existsSync(this.statePath)) {
      return {
        activeReleaseId: null,
        history: []
      };
    }

    const parsed = JSON.parse(readFileSync(this.statePath, "utf8")) as Partial<ContentReleaseState>;
    return {
      activeReleaseId: parsed.activeReleaseId ?? null,
      history: Array.isArray(parsed.history) ? parsed.history : []
    };
  }

  private saveState(state: ContentReleaseState): void {
    mkdirSync(path.dirname(this.statePath), { recursive: true });
    writeFileSync(this.statePath, JSON.stringify(state, null, 2));
  }
}
