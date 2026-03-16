import { redactAnalyticsEnvelope } from "../../privacy/redaction-rules";

describe("analytics redaction", () => {
  it("hashes identifiers and drops prohibited free text", () => {
    const redacted = redactAnalyticsEnvelope({
      user_id: "usr_private",
      session_id: "ses_private",
      properties: {
        vow_id: "vow_read",
        note_text: "free text",
        healthkit_payload: { steps: 1200 }
      }
    });

    expect(redacted.user_id).not.toBe("usr_private");
    expect(redacted.session_id).not.toBe("ses_private");
    expect(redacted.properties).toEqual({ vow_id: "vow_read" });
  });
});
