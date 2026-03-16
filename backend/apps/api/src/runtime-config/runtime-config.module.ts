import { Module } from "@nestjs/common";

import { AuditModule } from "../common/audit/audit.module";
import { SecurityModule } from "../common/security/security.module";
import { RuntimeConfigController } from "./runtime-config.controller";
import { RuntimeConfigService } from "./runtime-config.service";

@Module({
  imports: [AuditModule, SecurityModule],
  controllers: [RuntimeConfigController],
  providers: [RuntimeConfigService],
  exports: [RuntimeConfigService]
})
export class RuntimeConfigModule {}
