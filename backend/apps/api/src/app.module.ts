import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";

import { AnalyticsModule } from "./analytics/analytics.module";
import { AdminModule } from "./admin/admin.module";
import { AccountModule } from "./account/account.module";
import { AuthModule } from "./auth/auth.module";
import { AppConfigModule } from "./common/config/config.module";
import { DatabaseModule } from "./common/database/database.module";
import { RequestIdMiddleware } from "./common/http/request-id.middleware";
import { SecurityHeadersMiddleware } from "./common/security/security-headers.middleware";
import { ContentModule } from "./content/content.module";
import { CoreLoopModule } from "./core-loop/core-loop.module";
import { GlanceModule } from "./glance/glance.module";
import { HealthModule } from "./health/health.module";
import { ObservabilityModule } from "./observability/observability.module";
import { ProfileModule } from "./profile/profile.module";
import { ProgressionModule } from "./progression/progression.module";
import { RuntimeConfigModule } from "./runtime-config/runtime-config.module";
import { SubscriptionModule } from "./subscription/subscription.module";
import { VowsModule } from "./vows/vows.module";

@Module({
  imports: [
    AppConfigModule,
    DatabaseModule,
    HealthModule,
    ObservabilityModule,
    AnalyticsModule,
    AdminModule,
    AccountModule,
    RuntimeConfigModule,
    ContentModule,
    CoreLoopModule,
    GlanceModule,
    AuthModule,
    ProfileModule,
    SubscriptionModule,
    VowsModule,
    ProgressionModule
  ]
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(RequestIdMiddleware, SecurityHeadersMiddleware).forRoutes("*");
  }
}
