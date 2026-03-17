import { Module } from "@nestjs/common";

import { AuditModule } from "../common/audit/audit.module";
import { SecurityModule } from "../common/security/security.module";
import { ContentModule } from "../content/content.module";
import { CoreLoopModule } from "../core-loop/core-loop.module";
import { RuntimeConfigModule } from "../runtime-config/runtime-config.module";
import { AdminController } from "./admin.controller";
import { AssetReleaseService } from "./asset-release.service";
import { AdminService } from "./admin.service";

@Module({
  imports: [AuditModule, SecurityModule, RuntimeConfigModule, ContentModule, CoreLoopModule],
  controllers: [AdminController],
  providers: [AdminService, AssetReleaseService]
})
export class AdminModule {}
