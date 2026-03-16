import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { SubscriptionController } from "./subscription.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [SubscriptionController]
})
export class SubscriptionModule {}
