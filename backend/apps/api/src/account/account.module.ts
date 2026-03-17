import { Module } from "@nestjs/common";

import { AuditModule } from "../common/audit/audit.module";
import { CoreLoopModule } from "../core-loop/core-loop.module";
import { AccountController } from "./account.controller";

@Module({
  imports: [CoreLoopModule, AuditModule],
  controllers: [AccountController]
})
export class AccountModule {}
