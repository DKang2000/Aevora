import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { AuthController } from "./auth.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [AuthController]
})
export class AuthModule {}
