import { Body, Controller, HttpCode, Post } from "@nestjs/common";

import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller("subscription/storekit")
export class SubscriptionWebhookController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Post("notifications")
  @HttpCode(200)
  async applyStoreKitNotification(
    @Body()
    body: {
      notificationType: "DID_RENEW" | "DID_FAIL_TO_RENEW" | "DID_RECOVER" | "EXPIRED";
      subtype?: string | null;
      userId: string;
      tier?: "trial" | "premium_monthly" | "premium_annual" | null;
      transactionId?: string | null;
      expiresAt?: string | null;
    }
  ) {
    return this.coreLoopService.applyStoreKitServerNotification(body);
  }
}
