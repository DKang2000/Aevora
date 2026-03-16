import { AnalyticsEnvelope, commonAnalyticsEnvelopeSchema } from "./schema";

export function validateAnalyticsEvent(
  input: unknown
): { success: true; data: AnalyticsEnvelope } | { success: false; errors: string[] } {
  const result = commonAnalyticsEnvelopeSchema.safeParse(input);

  if (result.success) {
    return { success: true, data: result.data };
  }

  return {
    success: false,
    errors: result.error.issues.map((issue) => `${issue.path.join(".") || "root"}: ${issue.message}`)
  };
}

export function assertAnalyticsEvent(input: unknown): AnalyticsEnvelope {
  return commonAnalyticsEnvelopeSchema.parse(input);
}
