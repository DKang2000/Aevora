import { Controller, Get, Headers, Query } from "@nestjs/common";

import { AuditLogService } from "../common/audit/audit-log.service";
import { RateLimitService } from "../common/security/rate-limit.service";
import { ContentService } from "./content.service";

@Controller("content")
export class ContentController {
  constructor(
    private readonly contentService: ContentService,
    private readonly rateLimitService: RateLimitService,
    private readonly auditLogService: AuditLogService
  ) {}

  @Get("manifest")
  getManifest(
    @Headers("x-request-id") requestId?: string,
    @Headers("x-forwarded-for") actorKey?: string
  ): Record<string, unknown> {
    this.rateLimitService.check(`content:${actorKey ?? "local"}`, 10, 60_000);
    const manifest = this.contentService.getManifest();
    this.auditLogService.record({
      scope: "content",
      action: "serve_manifest",
      actorType: "system",
      requestId,
      metadata: manifest
    });
    return manifest;
  }

  @Get("bootstrap")
  getBootstrap(
    @Query("version") version?: string,
    @Headers("x-request-id") requestId?: string,
    @Headers("x-forwarded-for") actorKey?: string
  ): Record<string, unknown> {
    this.rateLimitService.check(`content:${actorKey ?? "local"}`, 10, 60_000);
    const bootstrap = this.contentService.getBootstrap(version);
    this.auditLogService.record({
      scope: "content",
      action: "serve_bootstrap",
      actorType: "system",
      requestId,
      metadata: {
        version: version ?? null
      }
    });
    return bootstrap;
  }
}
