import { BadRequestException, Injectable, InternalServerErrorException } from "@nestjs/common";
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

type AssetManifestPayload = {
  schemaVersion: string;
  releaseId: string;
  generatedAt: string;
  cdnBaseURL: string;
  assets: Array<{
    assetId: string;
    channel: string;
    logicalPath: string;
    artifactPath: string;
    contentHash: string;
    versionToken: string;
    contentType: string;
    cacheControl: string;
    sizeBytes: number;
  }>;
};

type AssetReleaseRecord = {
  id: string;
  label: string;
  manifestPath: string;
  schemaVersion: string;
  releaseId: string;
  assetCount: number;
  etag: string;
  promotedAt: string;
  promotedBy: string;
  notes?: string | null;
};

type AssetReleaseState = {
  activeReleaseId: string | null;
  history: AssetReleaseRecord[];
};

@Injectable()
export class AssetReleaseService {
  private readonly repoRoot = path.resolve(__dirname, "../../../../../");
  private readonly defaultManifestPath = path.resolve(this.repoRoot, "ops/assets/manifests/launch-assets.v1.json");
  private readonly statePath = process.env.AEVORA_ASSET_MANIFEST_STATE_PATH
    ? path.resolve(process.env.AEVORA_ASSET_MANIFEST_STATE_PATH)
    : path.join(tmpdir(), "aevora-asset-release-state.json");

  getReleaseStatus(): Record<string, unknown> {
    const state = this.loadState();
    const activeRelease = state.history.find((entry) => entry.id === state.activeReleaseId) ?? null;

    return {
      defaultManifestPath: this.defaultManifestPath,
      envOverridePath: process.env.AEVORA_ASSET_MANIFEST_OVERRIDE_PATH ?? null,
      activeRelease,
      history: state.history
    };
  }

  promoteRelease(input: {
    manifestPath: string;
    label: string;
    promotedBy: string;
    notes?: string;
  }): { release: AssetReleaseRecord; activeRelease: AssetReleaseRecord } {
    const resolvedPath = this.resolveRepoPath(input.manifestPath);
    const manifest = this.readAndValidate(resolvedPath);
    const state = this.loadState();
    const release: AssetReleaseRecord = {
      id: `ast_${this.createEtag(`${resolvedPath}:${Date.now()}:${input.label}`).slice(0, 12)}`,
      label: input.label,
      manifestPath: resolvedPath,
      schemaVersion: manifest.schemaVersion,
      releaseId: manifest.releaseId,
      assetCount: manifest.assets.length,
      etag: this.createEtag(manifest),
      promotedAt: new Date().toISOString(),
      promotedBy: input.promotedBy,
      notes: input.notes ?? null
    };

    const nextState: AssetReleaseState = {
      activeReleaseId: release.id,
      history: [release, ...state.history].slice(0, 20)
    };

    this.saveState(nextState);
    return {
      release,
      activeRelease: release
    };
  }

  private readAndValidate(targetPath: string): AssetManifestPayload {
    if (!existsSync(targetPath)) {
      throw new InternalServerErrorException(`Asset manifest not found at ${targetPath}.`);
    }

    const payload = JSON.parse(readFileSync(targetPath, "utf8")) as Partial<AssetManifestPayload>;
    if (
      !payload.schemaVersion ||
      !payload.releaseId ||
      !payload.generatedAt ||
      !payload.cdnBaseURL ||
      !Array.isArray(payload.assets)
    ) {
      throw new InternalServerErrorException("Invalid asset manifest.");
    }

    for (const asset of payload.assets) {
      if (
        !asset.assetId ||
        !asset.channel ||
        !asset.logicalPath ||
        !asset.artifactPath ||
        !asset.contentHash ||
        !asset.versionToken ||
        !asset.contentType ||
        !asset.cacheControl ||
        typeof asset.sizeBytes !== "number"
      ) {
        throw new InternalServerErrorException("Invalid asset manifest entry.");
      }
    }

    return payload as AssetManifestPayload;
  }

  private resolveRepoPath(candidatePath: string): string {
    if (!candidatePath.trim()) {
      throw new BadRequestException("Manifest path is required.");
    }

    const resolved = path.isAbsolute(candidatePath)
      ? path.resolve(candidatePath)
      : path.resolve(this.repoRoot, candidatePath);

    if (!resolved.startsWith(`${this.repoRoot}${path.sep}`) && resolved !== this.defaultManifestPath) {
      throw new BadRequestException("Manifest path must stay within the repo.");
    }

    return resolved;
  }

  private createEtag(payload: unknown): string {
    return createHash("sha256").update(JSON.stringify(payload)).digest("hex");
  }

  private loadState(): AssetReleaseState {
    if (!existsSync(this.statePath)) {
      return {
        activeReleaseId: null,
        history: []
      };
    }

    const parsed = JSON.parse(readFileSync(this.statePath, "utf8")) as Partial<AssetReleaseState>;
    return {
      activeReleaseId: parsed.activeReleaseId ?? null,
      history: Array.isArray(parsed.history) ? parsed.history : []
    };
  }

  private saveState(state: AssetReleaseState): void {
    mkdirSync(path.dirname(this.statePath), { recursive: true });
    writeFileSync(this.statePath, JSON.stringify(state, null, 2));
  }
}
