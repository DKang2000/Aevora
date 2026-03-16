import { assertAnalyticsEvent, validateAnalyticsEvent } from "../index";

describe("analytics event validation", () => {
  it("accepts a valid event envelope", () => {
    const result = validateAnalyticsEvent({
      event_name: "vow_completed",
      event_version: "v1",
      occurred_at_utc: "2026-03-16T12:00:00Z",
      local_date: "2026-03-16",
      user_id: "usr_test",
      session_id: "ses_test",
      surface: "today",
      app_build: "1",
      platform: "ios",
      experiment_assignments: [],
      properties: { vow_id: "vow_read" }
    });

    expect(result.success).toBe(true);
  });

  it("normalizes root-level event-specific fields into properties", () => {
    const result = validateAnalyticsEvent({
      event_name: "vow_completed",
      event_version: "v1",
      occurred_at_utc: "2026-03-16T12:00:00Z",
      local_date: "2026-03-16",
      anonymous_device_id: "dev_test",
      session_id: "ses_test",
      surface: "today",
      app_build: "1",
      platform: "ios",
      vow_id: "vow_read"
    });

    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.properties.vow_id).toBe("vow_read");
      expect(result.data.experiment_assignments).toEqual([]);
    }
  });

  it("rejects unknown events and missing actor identifiers", () => {
    expect(() =>
      assertAnalyticsEvent({
        event_name: "unknown_event",
        event_version: "v1",
        occurred_at_utc: "2026-03-16T12:00:00Z",
        local_date: "2026-03-16",
        session_id: "ses_test",
        surface: "today",
        app_build: "1",
        platform: "ios",
        experiment_assignments: [],
        properties: {}
      })
    ).toThrow();
  });
});
