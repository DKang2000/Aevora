import { mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AppModule } from "../src/app.module";

describe("Observability", () => {
  let app: INestApplication;

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
      mkdtempSync(path.join(tmpdir(), "aevora-observability-core-loop-state-")),
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

  it("exposes observability snapshots for admin flows", async () => {
    const response = await request(app.getHttpServer())
      .get("/v1/observability/metrics")
      .set("x-aevora-role", "admin")
      .expect(200);

    expect(response.body.metrics).toBeDefined();
    expect(Array.isArray(response.body.recentLogs)).toBe(true);
  });
});
