import { Injectable } from "@nestjs/common";
import { createHash } from "node:crypto";

import { assertAnalyticsEvent, redactAnalyticsEnvelope } from "@aevora/analytics-schema";

import { AuditLogService } from "../common/audit/audit-log.service";
import { MetricsService } from "../observability/metrics.service";
import { StructuredLoggerService } from "../observability/structured-logger.service";

export interface AnalyticsIngestionResult {
  accepted: number;
  duplicates: number;
  rejected: number;
}

@Injectable()
export class AnalyticsService {
  private readonly seenEventIds = new Set<string>();
  private readonly storedEvents: Record<string, unknown>[] = [];

  constructor(
    private readonly auditLog: AuditLogService,
    private readonly metrics: MetricsService,
    private readonly logger: StructuredLoggerService
  ) {}

  ingestBatch(events: unknown[], context: { requestId?: string }): AnalyticsIngestionResult {
    const result: AnalyticsIngestionResult = { accepted: 0, duplicates: 0, rejected: 0 };

    for (const event of events) {
      try {
        const normalized = assertAnalyticsEvent(event);
        const dedupeKey = this.createDedupeKey(normalized as unknown as Record<string, unknown>);

        if (this.seenEventIds.has(dedupeKey)) {
          result.duplicates += 1;
          continue;
        }

        this.seenEventIds.add(dedupeKey);
        this.storedEvents.push(redactAnalyticsEnvelope(normalized as unknown as Record<string, unknown>));
        this.metrics.increment("analytics_events_accepted");
        result.accepted += 1;
      } catch (error) {
        result.rejected += 1;
        this.metrics.increment("analytics_events_rejected");
        this.auditLog.record({
          scope: "analytics",
          action: "reject_event",
          actorType: "system",
          requestId: context.requestId,
          metadata: {
            error: error instanceof Error ? error.message : "unknown_error"
          }
        });
      }
    }

    this.logger.info(
      "Processed analytics batch.",
      result as unknown as Record<string, unknown>,
      "analytics"
    );
    return result;
  }

  listStoredEvents(): Record<string, unknown>[] {
    return [...this.storedEvents];
  }

  private createDedupeKey(event: Record<string, unknown>): string {
    const canonical = JSON.stringify({
      event_name: event.event_name,
      occurred_at_utc: event.occurred_at_utc,
      session_id: event.session_id,
      local_date: event.local_date,
      user_id: event.user_id,
      anonymous_device_id: event.anonymous_device_id,
      properties: event.properties
    });

    return createHash("sha256").update(canonical).digest("hex");
  }
}
