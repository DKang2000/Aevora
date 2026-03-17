import { Injectable } from "@nestjs/common";

import { AuditLogService } from "../common/audit/audit-log.service";
import { ContentService } from "../content/content.service";
import { CoreLoopService } from "../core-loop/core-loop.service";
import { RuntimeConfigService } from "../runtime-config/runtime-config.service";
import { AssetReleaseService } from "./asset-release.service";

@Injectable()
export class AdminService {
  constructor(
    private readonly runtimeConfigService: RuntimeConfigService,
    private readonly contentService: ContentService,
    private readonly assetReleaseService: AssetReleaseService,
    private readonly coreLoopService: CoreLoopService,
    private readonly auditLogService: AuditLogService
  ) {}

  getRuntimeConfigReleaseState(): Record<string, unknown> {
    return this.runtimeConfigService.getReleaseStatus();
  }

  promoteRuntimeConfig(
    input: { candidatePath: string; label: string; notes?: string },
    actorId: string,
    requestId?: string
  ): Record<string, unknown> {
    const result = this.runtimeConfigService.promoteRelease({
      ...input,
      promotedBy: actorId
    });

    this.auditLogService.record({
      scope: "admin_runtime_config",
      action: "promote_release",
      actorType: "admin",
      actorId,
      requestId,
      metadata: {
        label: result.release.label,
        sourcePath: result.release.sourcePath,
        schemaVersion: result.release.schemaVersion
      }
    });

    return result;
  }

  getContentReleaseState(): Record<string, unknown> {
    return this.contentService.getReleaseStatus();
  }

  promoteContent(
    input: { contentPath: string; copyPath?: string; label: string; notes?: string },
    actorId: string,
    requestId?: string
  ): Record<string, unknown> {
    const result = this.contentService.promoteRelease({
      ...input,
      promotedBy: actorId
    });

    this.auditLogService.record({
      scope: "admin_content",
      action: "promote_release",
      actorType: "admin",
      actorId,
      requestId,
      metadata: {
        label: result.release.label,
        contentPath: result.release.contentPath,
        copyPath: result.release.copyPath,
        contentVersion: result.release.contentVersion
      }
    });

    return result;
  }

  getAssetReleaseState(): Record<string, unknown> {
    return this.assetReleaseService.getReleaseStatus();
  }

  promoteAssetManifest(
    input: { manifestPath: string; label: string; notes?: string },
    actorId: string,
    requestId?: string
  ): Record<string, unknown> {
    const result = this.assetReleaseService.promoteRelease({
      ...input,
      promotedBy: actorId
    });

    this.auditLogService.record({
      scope: "admin_assets",
      action: "promote_release",
      actorType: "admin",
      actorId,
      requestId,
      metadata: {
        label: result.release.label,
        manifestPath: result.release.manifestPath,
        assetCount: result.release.assetCount
      }
    });

    return result;
  }

  async getAccountSummary(userId: string, actorId: string, requestId?: string): Promise<Record<string, unknown>> {
    const account = await this.coreLoopService.getAdminAccountSummary(userId);

    this.auditLogService.record({
      scope: "admin_account",
      action: "inspect_account",
      actorType: "admin",
      actorId,
      requestId,
      metadata: {
        targetUserId: userId
      }
    });

    return {
      account
    };
  }

  async prepareAccountExport(userId: string, actorId: string, requestId?: string): Promise<Record<string, unknown>> {
    const exportPayload = await this.coreLoopService.requestAccountExport(userId);

    this.auditLogService.record({
      scope: "admin_account",
      action: "prepare_export",
      actorType: "admin",
      actorId,
      requestId,
      metadata: {
        targetUserId: userId
      }
    });

    return exportPayload;
  }
}
