import { Module } from "@nestjs/common";

import { AuditModule } from "../common/audit/audit.module";
import { SecurityModule } from "../common/security/security.module";
import { ContentController } from "./content.controller";
import { ContentService } from "./content.service";

@Module({
  imports: [AuditModule, SecurityModule],
  controllers: [ContentController],
  providers: [ContentService],
  exports: [ContentService]
})
export class ContentModule {}
