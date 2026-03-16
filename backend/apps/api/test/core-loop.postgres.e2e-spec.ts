import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AppModule } from "../src/app.module";

const describePostgres = process.env.AEVORA_ENABLE_POSTGRES_E2E === "true" ? describe : describe.skip;

describePostgres("Postgres-backed durable starter arc core loop", () => {
  let app: INestApplication;

  const bootApp = async () => {
    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    app.setGlobalPrefix("v1");
    await app.init();
  };

  beforeEach(async () => {
    process.env.NODE_ENV = "test";
    process.env.PORT = "3001";
    process.env.API_BASE_URL = "http://localhost:3001";
    process.env.AUTH_ISSUER = "aevora-test";
    process.env.AUTH_AUDIENCE = "aevora-ios";
    process.env.ANALYTICS_PROVIDER = "console";
    process.env.OBSERVABILITY_PROVIDER = "console";
    process.env.REMOTE_CONFIG_SOURCE = "file";
    process.env.CONTENT_SOURCE = "file";
    process.env.CORE_LOOP_PERSISTENCE = "prisma";

    await bootApp();
  });

  afterEach(async () => {
    delete process.env.CORE_LOOP_PERSISTENCE;
    await app.close();
  });

  it("persists core-loop and subscription continuity across relaunches via Postgres", async () => {
    const guest = await request(app.getHttpServer())
      .post("/v1/auth/guest")
      .send({ deviceId: "device-postgres-runtime" })
      .expect(200)
      .then((response) => response.body);

    const authHeader = { Authorization: `Bearer ${guest.accessToken}` };

    const vow = await request(app.getHttpServer())
      .post("/v1/vows")
      .set(authHeader)
      .send({
        title: "Walk 10 minutes",
        type: "duration",
        category: "Physical",
        difficulty: "gentle",
        target: {
          value: 10,
          unit: "minutes"
        },
        schedule: {
          cadence: "daily",
          activeWeekdays: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"],
          reminderLocalTime: "08:00"
        }
      })
      .expect(201)
      .then((response) => response.body.vow);

    await request(app.getHttpServer())
      .post("/v1/completions")
      .set(authHeader)
      .send({
        clientRequestId: "cmp_postgres_day_1",
        vowId: vow.id,
        localDate: "2026-03-16",
        source: "manual",
        progressState: "complete",
        durationMinutes: 10
      })
      .expect(200);

    await request(app.getHttpServer())
      .post("/v1/subscription/trial")
      .set(authHeader)
      .send({ source: "paywall" })
      .expect(200);

    const refreshToken = guest.refreshToken;

    await app.close();
    await bootApp();

    const restored = await request(app.getHttpServer())
      .post("/v1/auth/restore-session")
      .send({ refreshToken })
      .expect(200)
      .then((response) => response.body);

    const restoredHeader = { Authorization: `Bearer ${restored.accessToken}` };

    const progression = await request(app.getHttpServer())
      .get("/v1/progression/snapshot")
      .set(restoredHeader)
      .expect(200)
      .then((response) => response.body);

    expect(progression.activeChapter.currentDay).toBe(1);

    const subscription = await request(app.getHttpServer())
      .get("/v1/subscription/state")
      .set(restoredHeader)
      .expect(200)
      .then((response) => response.body);

    expect(subscription.subscriptionState.tier).toBe("trial");

    const inventory = await request(app.getHttpServer())
      .get("/v1/inventory")
      .set(restoredHeader)
      .expect(200)
      .then((response) => response.body);

    expect(inventory.items[0].itemDefinitionId).toBe("ember_quay_token");

    const offers = await request(app.getHttpServer())
      .get("/v1/shop/offers")
      .set(restoredHeader)
      .expect(200)
      .then((response) => response.body.offers);

    expect(Array.isArray(offers)).toBe(true);
  });
});
