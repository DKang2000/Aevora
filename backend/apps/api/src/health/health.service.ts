import { Injectable } from "@nestjs/common";

import { AppConfigService } from "../common/config/config.service";

@Injectable()
export class HealthService {
  constructor(private readonly config: AppConfigService) {}

  getHealth(context: { requestId?: string }): Record<string, unknown> {
    return {
      status: "ok",
      service: "aevora-api",
      environment: this.config.environment,
      requestId: context.requestId ?? null,
      uptimeSeconds: Math.floor(process.uptime())
    };
  }

  getReadiness(context: { requestId?: string }): Record<string, unknown> {
    return {
      status: "ready",
      checks: {
        configLoaded: true,
        databaseConfigured: Boolean(this.config.databaseUrl)
      },
      requestId: context.requestId ?? null
    };
  }
}
