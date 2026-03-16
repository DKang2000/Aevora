import { Module } from "@nestjs/common";

import { AuditModule } from "../common/audit/audit.module";
import { SecurityModule } from "../common/security/security.module";
import { ObservabilityModule } from "../observability/observability.module";
import { AnalyticsController } from "./analytics.controller";
import { AnalyticsService } from "./analytics.service";

@Module({
  imports: [AuditModule, SecurityModule, ObservabilityModule],
  controllers: [AnalyticsController],
  providers: [AnalyticsService],
  exports: [AnalyticsService]
})
export class AnalyticsModule {}
