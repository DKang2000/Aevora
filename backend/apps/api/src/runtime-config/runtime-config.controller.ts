import { Controller, Get, Headers } from "@nestjs/common";

import { AuditLogService } from "../common/audit/audit-log.service";
import { RateLimitService } from "../common/security/rate-limit.service";
import { RuntimeConfigService } from "./runtime-config.service";

@Controller("remote-config")
export class RuntimeConfigController {
  constructor(
    private readonly runtimeConfigService: RuntimeConfigService,
    private readonly rateLimitService: RateLimitService,
    private readonly auditLogService: AuditLogService
  ) {}

  @Get()
  getRuntimeConfig(
    @Headers("x-request-id") requestId?: string,
    @Headers("x-forwarded-for") actorKey?: string
  ): Record<string, unknown> {
    this.rateLimitService.check(`remote-config:${actorKey ?? "local"}`, 20, 60_000);
    const config = this.runtimeConfigService.getConfig();

    this.auditLogService.record({
      scope: "runtime_config",
      action: "serve_remote_config",
      actorType: "system",
      requestId,
      metadata: {
        source: config.source
      }
    });

    return config;
  }
}
