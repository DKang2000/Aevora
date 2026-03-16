import { Body, Controller, Post, Headers, UseGuards } from "@nestjs/common";

import { AdminRoleGuard } from "../common/security/admin-role.guard";
import { RateLimitService } from "../common/security/rate-limit.service";
import { AnalyticsService } from "./analytics.service";

type AnalyticsBatchBody = {
  events?: unknown[];
};

@Controller("analytics")
export class AnalyticsController {
  constructor(
    private readonly analyticsService: AnalyticsService,
    private readonly rateLimitService: RateLimitService
  ) {}

  @Post("events")
  ingestEvents(
    @Body() body: AnalyticsBatchBody,
    @Headers("x-request-id") requestId?: string,
    @Headers("x-forwarded-for") actorKey?: string
  ): Record<string, unknown> {
    this.rateLimitService.check(`analytics:${actorKey ?? "local"}`, 3, 60_000);

    return {
      status: "accepted",
      requestId: requestId ?? null,
      ...this.analyticsService.ingestBatch(body.events ?? [], { requestId })
    };
  }

  @Post("events/admin-preview")
  @UseGuards(AdminRoleGuard)
  previewStoredEvents(): Record<string, unknown> {
    return {
      events: this.analyticsService.listStoredEvents()
    };
  }
}
