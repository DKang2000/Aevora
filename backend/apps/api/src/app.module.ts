import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";

import { AnalyticsModule } from "./analytics/analytics.module";
import { AppConfigModule } from "./common/config/config.module";
import { RequestIdMiddleware } from "./common/http/request-id.middleware";
import { SecurityHeadersMiddleware } from "./common/security/security-headers.middleware";
import { ContentModule } from "./content/content.module";
import { HealthModule } from "./health/health.module";
import { ObservabilityModule } from "./observability/observability.module";
import { RuntimeConfigModule } from "./runtime-config/runtime-config.module";

@Module({
  imports: [
    AppConfigModule,
    HealthModule,
    ObservabilityModule,
    AnalyticsModule,
    RuntimeConfigModule,
    ContentModule
  ]
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(RequestIdMiddleware, SecurityHeadersMiddleware).forRoutes("*");
  }
}
