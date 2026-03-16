import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import request from "supertest";

import { AppModule } from "../src/app.module";

describe("Security and audit", () => {
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

    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    app.setGlobalPrefix("v1");
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it("applies security headers", async () => {
    const response = await request(app.getHttpServer()).get("/v1/health").expect(200);
    expect(response.headers["x-content-type-options"]).toBe("nosniff");
    expect(response.headers["x-frame-options"]).toBe("DENY");
  });

  it("rate limits analytics ingestion after repeated requests", async () => {
    for (let attempt = 0; attempt < 3; attempt += 1) {
      await request(app.getHttpServer())
        .post("/v1/analytics/events")
        .set("x-forwarded-for", "ratelimit-test")
        .send({ events: [] })
        .expect(201);
    }

    await request(app.getHttpServer())
      .post("/v1/analytics/events")
      .set("x-forwarded-for", "ratelimit-test")
      .send({ events: [] })
      .expect(429);
  });

  it("protects audit entries behind the admin role header", async () => {
    await request(app.getHttpServer())
      .get("/v1/audit/admin")
      .set("x-request-id", "req_audit")
      .expect(401);
  });
});
