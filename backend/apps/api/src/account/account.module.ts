import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { AccountController } from "./account.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [AccountController]
})
export class AccountModule {}
