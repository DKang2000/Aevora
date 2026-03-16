import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { ProgressionController } from "./progression.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [ProgressionController]
})
export class ProgressionModule {}
