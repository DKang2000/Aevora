import { ConflictException, Injectable, InternalServerErrorException } from "@nestjs/common";
import { createHash } from "node:crypto";
import { existsSync, readFileSync } from "node:fs";
import path from "node:path";

type ContentPayload = Record<string, unknown> & {
  schemaVersion: string;
};

@Injectable()
export class ContentService {
  private readonly repoRoot = path.resolve(__dirname, "../../../../../");
  private readonly contentPath = path.resolve(this.repoRoot, "content/launch/launch-content.min.v1.json");
  private readonly copyPath = path.resolve(this.repoRoot, "content/launch/copy/en/core.v1.json");

  getManifest(): Record<string, unknown> {
    const content = this.readAndValidate(process.env.AEVORA_CONTENT_OVERRIDE_PATH ?? this.contentPath);
    const copy = this.readJson(process.env.AEVORA_COPY_OVERRIDE_PATH ?? this.copyPath);

    return {
      contentVersion: content.schemaVersion,
      copyVersion: (copy as { schemaVersion?: string }).schemaVersion ?? "v1",
      etag: this.createEtag({ content, copy })
    };
  }

  getBootstrap(requestedVersion?: string): Record<string, unknown> {
    const content = this.readAndValidate(process.env.AEVORA_CONTENT_OVERRIDE_PATH ?? this.contentPath);
    const copy = this.readJson(process.env.AEVORA_COPY_OVERRIDE_PATH ?? this.copyPath);

    if (requestedVersion && requestedVersion !== content.schemaVersion) {
      throw new ConflictException("Requested content version does not match current launch content.");
    }

    return {
      manifest: this.getManifest(),
      content,
      copy
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
}
