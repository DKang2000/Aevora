import { Controller, Get, Headers } from "@nestjs/common";

import { HealthService } from "./health.service";

@Controller("health")
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  getHealth(@Headers("x-request-id") requestId?: string): Record<string, unknown> {
    return this.healthService.getHealth({ requestId });
  }

  @Get("ready")
  getReadiness(@Headers("x-request-id") requestId?: string): Record<string, unknown> {
    return this.healthService.getReadiness({ requestId });
  }
}
