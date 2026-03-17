import { mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AppModule } from "../src/app.module";

describe("Admin publishing and support surfaces", () => {
  let app: INestApplication;

  beforeEach(async () => {
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
    process.env.AEVORA_REMOTE_CONFIG_STATE_PATH = path.join(
      mkdtempSync(path.join(tmpdir(), "aevora-admin-config-state-")),
      "runtime-config-state.json"
    );
    process.env.AEVORA_CONTENT_STATE_PATH = path.join(
      mkdtempSync(path.join(tmpdir(), "aevora-admin-content-state-")),
      "content-state.json"
    );
    process.env.AEVORA_ASSET_MANIFEST_STATE_PATH = path.join(
      mkdtempSync(path.join(tmpdir(), "aevora-admin-assets-state-")),
      "asset-state.json"
    );
    process.env.AEVORA_CORE_LOOP_STORE_PATH = path.join(
      mkdtempSync(path.join(tmpdir(), "aevora-admin-core-loop-state-")),
      "core-loop-store.json"
    );

    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    app.setGlobalPrefix("v1");
    await app.init();
  });

  afterEach(async () => {
    delete process.env.AEVORA_REMOTE_CONFIG_STATE_PATH;
    delete process.env.AEVORA_CONTENT_STATE_PATH;
    delete process.env.AEVORA_ASSET_MANIFEST_STATE_PATH;
    delete process.env.AEVORA_CORE_LOOP_STORE_PATH;
    await app.close();
  });

  it("protects the admin surface and promotes launch publishing candidates", async () => {
    await request(app.getHttpServer()).get("/v1/admin/runtime-config/releases/current").expect(401);

    const adminHeaders = {
      "x-aevora-role": "admin",
      "x-aevora-actor-id": "operator_launch"
    };

    const runtimeRelease = await request(app.getHttpServer())
      .post("/v1/admin/runtime-config/releases/promote")
      .set(adminHeaders)
      .send({
        candidatePath: "shared/contracts/remote-config/defaults/launch-defaults.v1.json",
        label: "launch-defaults"
      })
      .expect(201)
      .then((response) => response.body);

    expect(runtimeRelease.activeRelease.label).toBe("launch-defaults");

    const remoteConfig = await request(app.getHttpServer()).get("/v1/remote-config").expect(200);
    expect(remoteConfig.body.source).toBe("promoted_override");

    const contentRelease = await request(app.getHttpServer())
      .post("/v1/admin/content/releases/promote")
      .set(adminHeaders)
      .send({
        contentPath: "content/launch/launch-content.min.v1.json",
        copyPath: "content/launch/copy/en/core.v1.json",
        label: "launch-content"
      })
      .expect(201)
      .then((response) => response.body);

    expect(contentRelease.activeRelease.contentVersion).toBe("v1");

    const contentManifest = await request(app.getHttpServer()).get("/v1/content/manifest").expect(200);
    expect(contentManifest.body.source).toBe("promoted_override");

    const assetRelease = await request(app.getHttpServer())
      .post("/v1/admin/assets/releases/promote")
      .set(adminHeaders)
      .send({
        manifestPath: "ops/assets/manifests/launch-assets.v1.json",
        label: "placeholder-assets"
      })
      .expect(201)
      .then((response) => response.body);

    expect(assetRelease.activeRelease.assetCount).toBeGreaterThan(0);
  });

  it("returns support-safe account inspection and export data for an operator", async () => {
    const guest = await request(app.getHttpServer())
      .post("/v1/auth/guest")
      .send({ deviceId: "device-admin-lookup" })
      .expect(200)
      .then((response) => response.body);

    const authHeader = { Authorization: `Bearer ${guest.accessToken}` };
    const adminHeaders = {
      "x-aevora-role": "admin",
      "x-aevora-actor-id": "support_agent"
    };

    const vow = await request(app.getHttpServer())
      .post("/v1/vows")
      .set(authHeader)
      .send({
        title: "Walk 20 minutes",
        type: "duration",
        category: "Physical",
        difficulty: "gentle",
        target: {
          value: 20,
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
        clientRequestId: "cmp_admin_account_lookup",
        vowId: vow.id,
        localDate: "2026-03-16",
        source: "manual",
        progressState: "complete",
        quantity: 20
      })
      .expect(200);

    const summary = await request(app.getHttpServer())
      .get(`/v1/admin/accounts/${guest.user.id}`)
      .set(adminHeaders)
      .expect(200)
      .then((response) => response.body.account);

    expect(summary.userId).toBe(guest.user.id);
    expect(summary.activeVowCount).toBeGreaterThanOrEqual(1);
    expect(summary.completionDayCount).toBe(1);

    const exportResponse = await request(app.getHttpServer())
      .post(`/v1/admin/accounts/${guest.user.id}/export`)
      .set(adminHeaders)
      .expect(201)
      .then((response) => response.body);

    expect(exportResponse.exportRequest.redactionProfile).toBe("support_safe_v1");
    expect(exportResponse.summary.lastCompletionLocalDate).toBe("2026-03-16");
  });
});
