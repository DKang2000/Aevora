import { Injectable, InternalServerErrorException } from "@nestjs/common";
import { createHash } from "node:crypto";
import { existsSync, readFileSync } from "node:fs";
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

@Injectable()
export class RuntimeConfigService {
  private readonly repoRoot = path.resolve(__dirname, "../../../../../");
  private readonly defaultPath = path.resolve(
    this.repoRoot,
    "shared/contracts/remote-config/defaults/launch-defaults.v1.json"
  );

  getConfig(): { etag: string; payload: RuntimeConfigPayload; source: string } {
    const overridePath = process.env.AEVORA_REMOTE_CONFIG_OVERRIDE_PATH;
    const fallbackPayload = this.readAndValidate(this.defaultPath);

    if (!overridePath) {
      return {
        etag: this.createEtag(fallbackPayload),
        payload: fallbackPayload,
        source: "default"
      };
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
}
