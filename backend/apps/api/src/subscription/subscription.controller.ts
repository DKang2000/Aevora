import { Body, Controller, Get, HttpCode, Post, UseGuards } from "@nestjs/common";

import { CurrentUser } from "../common/auth/current-user.decorator";
import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller("subscription")
@UseGuards(SessionAuthGuard)
export class SubscriptionController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Get("state")
  async getSubscriptionState(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getSubscriptionState(user.id);
  }

  @Post("trial")
  @HttpCode(200)
  async startTrial(@CurrentUser() user: { id: string }, @Body() body: { source?: string }) {
    return this.coreLoopService.startTrial(user.id, body.source);
  }

  @Post("purchase")
  @HttpCode(200)
  async purchaseSubscription(
    @CurrentUser() user: { id: string },
    @Body() body: { tier: "premium_monthly" | "premium_annual"; source?: string }
  ) {
    return this.coreLoopService.purchaseSubscription(user.id, body.tier, body.source);
  }

  @Post("restore")
  @HttpCode(200)
  async restoreSubscription(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.restoreSubscription(user.id);
  }

  @Post("downgrade")
  @HttpCode(200)
  async downgradeSubscription(@CurrentUser() user: { id: string }, @Body() body: { reason?: string }) {
    return this.coreLoopService.downgradeSubscription(user.id, body.reason);
  }

  @Post("refresh")
  @HttpCode(200)
  async refreshSubscription(
    @CurrentUser() user: { id: string },
    @Body()
    body: {
      transactionId: string;
      originalTransactionId?: string | null;
      tier: "trial" | "premium_monthly" | "premium_annual";
      billingState?: "active" | "grace_period" | "billing_retry" | "expired";
      expiresAt?: string | null;
    }
  ) {
    return this.coreLoopService.refreshSubscriptionFromTransaction(user.id, body);
  }
}
