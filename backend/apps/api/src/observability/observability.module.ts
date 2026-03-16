import { Module } from "@nestjs/common";

import { SecurityModule } from "../common/security/security.module";
import { MetricsService } from "./metrics.service";
import { ObservabilityController } from "./observability.controller";
import { StructuredLoggerService } from "./structured-logger.service";

@Module({
  imports: [SecurityModule],
  controllers: [ObservabilityController],
  providers: [MetricsService, StructuredLoggerService],
  exports: [MetricsService, StructuredLoggerService]
})
export class ObservabilityModule {}
