import { mkdtempSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AppModule } from "../src/app.module";

describe("Content delivery", () => {
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

    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    app.setGlobalPrefix("v1");
    await app.init();
  });

  afterEach(async () => {
    delete process.env.AEVORA_CONTENT_OVERRIDE_PATH;
    await app.close();
  });

  it("returns a content manifest", async () => {
    const response = await request(app.getHttpServer()).get("/v1/content/manifest").expect(200);
    expect(response.body.contentVersion).toBe("v1");
  });

  it("rejects a bootstrap request with a mismatched version", async () => {
    await request(app.getHttpServer()).get("/v1/content/bootstrap?version=legacy").expect(409);
  });

  it("fails fast for invalid content payloads", async () => {
    const dir = mkdtempSync(path.join(tmpdir(), "aevora-content-"));
    const invalidPath = path.join(dir, "invalid.json");
    writeFileSync(invalidPath, JSON.stringify({ schemaVersion: "v1" }));
    process.env.AEVORA_CONTENT_OVERRIDE_PATH = invalidPath;

    await app.close();
    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    app.setGlobalPrefix("v1");
    await app.init();

    await request(app.getHttpServer()).get("/v1/content/manifest").expect(500);
  });
});
