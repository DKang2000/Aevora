import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { GlanceController } from "./glance.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [GlanceController]
})
export class GlanceModule {}
