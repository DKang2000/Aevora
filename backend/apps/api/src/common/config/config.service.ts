import { Injectable } from "@nestjs/common";

import { AppConfig, appConfigSchema } from "./env";

@Injectable()
export class AppConfigService {
  private readonly parsedConfig: AppConfig;

  constructor() {
    this.parsedConfig = appConfigSchema.parse(process.env);
  }

  get all(): AppConfig {
    return this.parsedConfig;
  }

  get environment(): AppConfig["NODE_ENV"] {
    return this.parsedConfig.NODE_ENV;
  }

  get port(): number {
    return this.parsedConfig.PORT;
  }

  get databaseUrl(): string {
    return this.parsedConfig.DATABASE_URL;
  }
}
