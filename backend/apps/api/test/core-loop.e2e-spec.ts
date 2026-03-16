import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AppModule } from "../src/app.module";

describe("Durable starter arc core loop", () => {
  let app: INestApplication;
  let storeDir: string;

  const bootApp = async () => {
    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    app.setGlobalPrefix("v1");
    await app.init();
  };

  beforeEach(async () => {
    storeDir = mkdtempSync(path.join(tmpdir(), "aevora-core-loop-"));

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
    process.env.CORE_LOOP_PERSISTENCE = "file";
    process.env.AEVORA_CORE_LOOP_STORE_PATH = path.join(storeDir, "core-loop-store.json");

    await bootApp();
  });

  afterEach(async () => {
    delete process.env.CORE_LOOP_PERSISTENCE;
    delete process.env.AEVORA_CORE_LOOP_STORE_PATH;
    await app.close();
    rmSync(storeDir, { recursive: true, force: true });
  });

  it("persists guest progress across relaunch and restore session", async () => {
    const guest = await request(app.getHttpServer())
      .post("/v1/auth/guest")
      .send({ deviceId: "device-core-loop" })
      .expect(200)
      .then((response) => response.body);

    const authHeader = { Authorization: `Bearer ${guest.accessToken}` };

    const createdVow = await request(app.getHttpServer())
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
        clientRequestId: "cmp_day_1",
        vowId: createdVow.id,
        localDate: "2026-03-16",
        source: "manual",
        progressState: "complete",
        durationMinutes: 10
      })
      .expect(200);

    await app.close();
    await bootApp();

    const restored = await request(app.getHttpServer())
      .post("/v1/auth/restore-session")
      .send({ refreshToken: guest.refreshToken })
      .expect(200)
      .then((response) => response.body);

    const restoredHeader = { Authorization: `Bearer ${restored.accessToken}` };

    const progression = await request(app.getHttpServer())
      .get("/v1/progression/snapshot")
      .set(restoredHeader)
      .expect(200)
      .then((response) => response.body);

    expect(progression.activeChapter.chapterId).toBe("starter_arc");
    expect(progression.activeChapter.currentDay).toBe(1);

    const worldState = await request(app.getHttpServer())
      .get("/v1/world-state")
      .set(restoredHeader)
      .expect(200)
      .then((response) => response.body);

    expect(worldState.districtState.restorationStage).toBe("stirring");

    const inventory = await request(app.getHttpServer())
      .get("/v1/inventory")
      .set(restoredHeader)
      .expect(200)
      .then((response) => response.body);

    expect(inventory.items).toHaveLength(1);
    expect(inventory.items[0].itemDefinitionId).toBe("ember_quay_token");
  });

  it("supports a full 7-day starter arc with rekindling and day-7 closure rewards", async () => {
    const guest = await request(app.getHttpServer())
      .post("/v1/auth/guest")
      .send({ deviceId: "device-day-seven" })
      .expect(200)
      .then((response) => response.body);

    const authHeader = { Authorization: `Bearer ${guest.accessToken}` };

    const vow = await request(app.getHttpServer())
      .post("/v1/vows")
      .set(authHeader)
      .send({
        title: "Write one journal line",
        type: "binary",
        category: "Emotional",
        difficulty: "gentle",
        target: {
          value: 1,
          unit: "completion"
        },
        schedule: {
          cadence: "daily",
          activeWeekdays: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
        }
      })
      .expect(201)
      .then((response) => response.body.vow);

    const completionDates = [
      "2026-03-16",
      "2026-03-17",
      "2026-03-18",
      "2026-03-21",
      "2026-03-22",
      "2026-03-23",
      "2026-03-24"
    ];

    for (const [index, localDate] of completionDates.entries()) {
      await request(app.getHttpServer())
        .post("/v1/completions")
        .set(authHeader)
        .send({
          clientRequestId: `cmp_day_${index + 1}`,
          vowId: vow.id,
          localDate,
          source: "manual",
          progressState: "complete"
        })
        .expect(200);
    }

    const progression = await request(app.getHttpServer())
      .get("/v1/progression/snapshot")
      .set(authHeader)
      .expect(200)
      .then((response) => response.body);

    expect(progression.activeChapter.status).toBe("completed");
    expect(progression.activeChapter.currentDay).toBe(7);
    expect(progression.emberState.availableEmbers).toBe(1);

    const worldState = await request(app.getHttpServer())
      .get("/v1/world-state")
      .set(authHeader)
      .expect(200)
      .then((response) => response.body);

    expect(worldState.districtState.restorationStage).toBe("rekindled");

    const inventory = await request(app.getHttpServer())
      .get("/v1/inventory")
      .set(authHeader)
      .expect(200)
      .then((response) => response.body);

    expect(inventory.items.map((item: { itemDefinitionId: string }) => item.itemDefinitionId)).toEqual(
      expect.arrayContaining(["ember_quay_token", "hearth_apron_common"])
    );
  });

  it("preserves trial continuity through guest linking, downgrade, restore, and relaunch", async () => {
    const guest = await request(app.getHttpServer())
      .post("/v1/auth/guest")
      .send({ deviceId: "device-trial-link" })
      .expect(200)
      .then((response) => response.body);

    const authHeader = { Authorization: `Bearer ${guest.accessToken}` };

    const trialStart = await request(app.getHttpServer())
      .post("/v1/subscription/trial")
      .set(authHeader)
      .send({ source: "paywall" })
      .expect(200)
      .then((response) => response.body);

    expect(trialStart.subscriptionState.tier).toBe("trial");
    expect(trialStart.subscriptionState.trialEligible).toBe(false);

    const linked = await request(app.getHttpServer())
      .post("/v1/auth/link-account")
      .send({ guestUserId: guest.user.id, identityToken: "apple-linked-trial-user" })
      .expect(200)
      .then((response) => response.body);

    const linkedHeader = { Authorization: `Bearer ${linked.accessToken}` };

    const linkedSubscription = await request(app.getHttpServer())
      .get("/v1/subscription/state")
      .set(linkedHeader)
      .expect(200)
      .then((response) => response.body);

    expect(linkedSubscription.subscriptionState.tier).toBe("trial");

    const downgraded = await request(app.getHttpServer())
      .post("/v1/subscription/downgrade")
      .set(linkedHeader)
      .send({ reason: "billing_retry_timeout" })
      .expect(200)
      .then((response) => response.body);

    expect(downgraded.subscriptionState.tier).toBe("free");
    expect(downgraded.subscriptionState.restoreTier).toBe("trial");

    const restored = await request(app.getHttpServer())
      .post("/v1/subscription/restore")
      .set(linkedHeader)
      .expect(200)
      .then((response) => response.body);

    expect(restored.restored).toBe(true);
    expect(restored.subscriptionState.tier).toBe("trial");

    const refreshToken = linked.refreshToken;
    await app.close();
    await bootApp();

    const relaunched = await request(app.getHttpServer())
      .post("/v1/auth/restore-session")
      .send({ refreshToken })
      .expect(200)
      .then((response) => response.body);

    const relaunchedHeader = { Authorization: `Bearer ${relaunched.accessToken}` };

    const relaunchedSubscription = await request(app.getHttpServer())
      .get("/v1/subscription/state")
      .set(relaunchedHeader)
      .expect(200)
      .then((response) => response.body);

    expect(relaunchedSubscription.subscriptionState.tier).toBe("trial");
    expect(relaunchedSubscription.subscriptionState.trialEligible).toBe(false);
  });

  it("returns account export and glance snapshots, then deletes the account cleanly", async () => {
    const guest = await request(app.getHttpServer())
      .post("/v1/auth/guest")
      .send({ deviceId: "device-account-export" })
      .expect(200)
      .then((response) => response.body);

    const authHeader = { Authorization: `Bearer ${guest.accessToken}` };

    const vow = await request(app.getHttpServer())
      .post("/v1/vows")
      .set(authHeader)
      .send({
        title: "Read 10 pages",
        type: "count",
        category: "Intellectual",
        difficulty: "standard",
        target: {
          value: 10,
          unit: "pages"
        },
        schedule: {
          cadence: "daily",
          activeWeekdays: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"],
          reminderLocalTime: "20:00"
        }
      })
      .expect(201)
      .then((response) => response.body.vow);

    await request(app.getHttpServer())
      .post("/v1/completions")
      .set(authHeader)
      .send({
        clientRequestId: "cmp_account_export_day_1",
        vowId: vow.id,
        localDate: "2026-03-16",
        source: "manual",
        progressState: "complete",
        quantity: 10
      })
      .expect(200);

    const glance = await request(app.getHttpServer())
      .get("/v1/glance/state")
      .set(authHeader)
      .expect(200)
      .then((response) => response.body);

    expect(glance.todaySnapshot.activeVowCount).toBe(1);
    expect(glance.todaySnapshot.chapterDay).toBe(1);

    const exportResponse = await request(app.getHttpServer())
      .post("/v1/account/export")
      .set(authHeader)
      .expect(200)
      .then((response) => response.body);

    expect(exportResponse.exportRequest.status).toBe("prepared");
    expect(exportResponse.summary.subscriptionTier).toBe("free");

    await request(app.getHttpServer())
      .delete("/v1/account")
      .set(authHeader)
      .expect(200);

    await request(app.getHttpServer())
      .get("/v1/account")
      .set(authHeader)
      .expect(401);
  });
});
