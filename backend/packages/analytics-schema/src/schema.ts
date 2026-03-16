import { z } from "zod";

import { analyticsEventNames, commonAnalyticsFields } from "./catalog";

export const analyticsEventNameSchema = z.enum(analyticsEventNames);

const commonFieldSet = new Set<string>([...commonAnalyticsFields, "properties"]);

export const commonAnalyticsEnvelopeSchema = z.preprocess((raw) => {
  if (!raw || typeof raw !== "object" || Array.isArray(raw)) {
    return raw;
  }

  const record = raw as Record<string, unknown>;
  const extraProperties = Object.fromEntries(
    Object.entries(record).filter(([key]) => !commonFieldSet.has(key))
  );

  return {
    ...record,
    experiment_assignments: record.experiment_assignments ?? [],
    properties: {
      ...(record.properties && typeof record.properties === "object" && !Array.isArray(record.properties)
        ? (record.properties as Record<string, unknown>)
        : {}),
      ...extraProperties
    }
  };
}, z.object({
  event_name: analyticsEventNameSchema,
  event_version: z.string().min(1),
  occurred_at_utc: z.string().datetime(),
  local_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  user_id: z.string().min(1).optional(),
  anonymous_device_id: z.string().min(1).optional(),
  session_id: z.string().min(1),
  surface: z.string().min(1),
  app_build: z.string().min(1),
  platform: z.enum(["ios"]),
  experiment_assignments: z.array(z.string()).default([]),
  properties: z.record(z.unknown()).default({})
}).refine(
  (value) => Boolean(value.user_id) || Boolean(value.anonymous_device_id),
  { message: "Either user_id or anonymous_device_id is required." }
));

export type AnalyticsEnvelope = z.infer<typeof commonAnalyticsEnvelopeSchema>;
