import { mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AppModule } from "../src/app.module";

describe("Analytics ingestion", () => {
  let app: INestApplication;

  const validEvent = {
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
    properties: { vow_id: "vow_walk" }
  };

  beforeAll(async () => {
    process.env.NODE_ENV = "test";
    process.env.PORT = "3001";
    process.env.DATABASE_URL = "postgresql://aevora:aevora@localhost:5432/aevora_test?schema=public";
    process.env.API_BASE_URL = "http://localhost:3001";
    process.env.AUTH_ISSUER = "aevora-test";
    process.env.AUTH_AUDIENCE = "aevora-ios";
    process.env.ANALYTICS_PROVIDER = "console";
    process.env.OBSERVABILITY_PROVIDER = "console";
    process.env.REMOTE_CONFIG_SOURCE = "file";
    process.env.CONTENT_SOURCE = "file";
    process.env.AEVORA_CORE_LOOP_STORE_PATH = path.join(
      mkdtempSync(path.join(tmpdir(), "aevora-analytics-core-loop-state-")),
      "core-loop-store.json"
    );

    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    app.setGlobalPrefix("v1");
    await app.init();
  });

  afterAll(async () => {
    delete process.env.AEVORA_CORE_LOOP_STORE_PATH;
    await app.close();
  });

  it("accepts valid analytics events", async () => {
    const response = await request(app.getHttpServer())
      .post("/v1/analytics/events")
      .set("x-request-id", "req_analytics")
      .set("x-forwarded-for", "analytics-ingest")
      .send({ events: [validEvent] })
      .expect(201);

    expect(response.body.accepted).toBe(1);
    expect(response.body.duplicates).toBe(0);
  });

  it("deduplicates repeated events", async () => {
    const dedupeEvent = {
      ...validEvent,
      occurred_at_utc: "2026-03-16T13:00:00Z"
    };
    const response = await request(app.getHttpServer())
      .post("/v1/analytics/events")
      .set("x-forwarded-for", "analytics-dedupe")
      .send({ events: [dedupeEvent, dedupeEvent] })
      .expect(201);

    expect(response.body.accepted).toBe(1);
    expect(response.body.duplicates).toBe(1);
  });

  it("rejects malformed events", async () => {
    const response = await request(app.getHttpServer())
      .post("/v1/analytics/events")
      .set("x-forwarded-for", "analytics-invalid")
      .send({ events: [{ event_name: "broken" }] })
      .expect(201);

    expect(response.body.rejected).toBe(1);
  });
});
