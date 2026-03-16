import { Controller, Get, UseGuards } from "@nestjs/common";

import { AdminRoleGuard } from "../common/security/admin-role.guard";
import { MetricsService } from "./metrics.service";
import { StructuredLoggerService } from "./structured-logger.service";

@Controller("observability")
@UseGuards(AdminRoleGuard)
export class ObservabilityController {
  constructor(
    private readonly metrics: MetricsService,
    private readonly logger: StructuredLoggerService
  ) {}

  @Get("metrics")
  getMetrics(): Record<string, unknown> {
    return {
      metrics: this.metrics.snapshot(),
      recentLogs: this.logger.recent().slice(0, 20)
    };
  }
}
