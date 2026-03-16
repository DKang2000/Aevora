import { Module } from "@nestjs/common";

import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "./core-loop.service";

@Module({
  providers: [CoreLoopService, SessionAuthGuard],
  exports: [CoreLoopService, SessionAuthGuard]
})
export class CoreLoopModule {}
