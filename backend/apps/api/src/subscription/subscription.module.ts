import { Module } from "@nestjs/common";

import { CoreLoopModule } from "../core-loop/core-loop.module";
import { SubscriptionController } from "./subscription.controller";
import { SubscriptionWebhookController } from "./subscription-webhook.controller";

@Module({
  imports: [CoreLoopModule],
  controllers: [SubscriptionController, SubscriptionWebhookController]
})
export class SubscriptionModule {}
