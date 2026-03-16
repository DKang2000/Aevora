import { z } from "zod";

export const appConfigSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "staging", "production"]).default("development"),
  PORT: z.coerce.number().int().min(1).max(65535).default(3000),
  DATABASE_URL: z.string().min(1),
  API_BASE_URL: z.string().url(),
  AUTH_ISSUER: z.string().min(1),
  AUTH_AUDIENCE: z.string().min(1),
  ANALYTICS_PROVIDER: z.string().min(1).default("console"),
  OBSERVABILITY_PROVIDER: z.string().min(1).default("console"),
  REMOTE_CONFIG_SOURCE: z.string().min(1).default("file"),
  CONTENT_SOURCE: z.string().min(1).default("file")
});

export type AppConfig = z.infer<typeof appConfigSchema>;
