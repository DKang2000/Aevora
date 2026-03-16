import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { ProfileController } from "./profile.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [ProfileController]
})
export class ProfileModule {}
