import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { VowsController } from "./vows.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [VowsController]
})
export class VowsModule {}
