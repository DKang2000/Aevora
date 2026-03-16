import { createHash } from "node:crypto";

const hashedKeys = new Set(["user_id", "anonymous_device_id", "session_id"]);
const droppedPropertyKeys = new Set(["note_text", "healthkit_payload"]);

function hashValue(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

export function redactAnalyticsEnvelope(
  input: Record<string, unknown>
): Record<string, unknown> {
  const redacted: Record<string, unknown> = {};

  for (const [key, value] of Object.entries(input)) {
    if (hashedKeys.has(key) && typeof value === "string") {
      redacted[key] = hashValue(value);
      continue;
    }

    if (key === "properties" && value && typeof value === "object" && !Array.isArray(value)) {
      const properties: Record<string, unknown> = {};
      for (const [propertyKey, propertyValue] of Object.entries(value)) {
        if (!droppedPropertyKeys.has(propertyKey)) {
          properties[propertyKey] = propertyValue;
        }
      }
      redacted[key] = properties;
      continue;
    }

    redacted[key] = value;
  }

  return redacted;
}
