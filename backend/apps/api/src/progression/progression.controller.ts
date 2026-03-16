import { Body, Controller, Get, HttpCode, Param, Post, UseGuards } from "@nestjs/common";

import { CurrentUser } from "../common/auth/current-user.decorator";
import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller()
@UseGuards(SessionAuthGuard)
export class ProgressionController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Post("completions")
  @HttpCode(200)
  async submitCompletion(@CurrentUser() user: { id: string }, @Body() body: Record<string, unknown>) {
    return this.coreLoopService.submitCompletion(user.id, body as never);
  }

  @Post("sync/operations")
  @HttpCode(200)
  async syncOperations(@CurrentUser() user: { id: string }, @Body() body: { operations: Array<Record<string, unknown>> }) {
    return this.coreLoopService.syncOperations(user.id, body.operations as never);
  }

  @Get("progression/snapshot")
  async getProgressionSnapshot(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getProgressionSnapshot(user.id);
  }

  @Get("chapters/current")
  async getCurrentChapter(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getCurrentChapter(user.id);
  }

  @Get("world-state")
  async getWorldState(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getWorldState(user.id);
  }

  @Get("inventory")
  async getInventory(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getInventory(user.id);
  }

  @Get("shop/offers")
  async getShopOffers(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getShopOffers(user.id);
  }

  @Post("shop/offers/:offerId/purchase")
  @HttpCode(200)
  async purchaseShopOffer(
    @CurrentUser() user: { id: string },
    @Param("offerId") offerId: string,
    @Body() body: { source?: string }
  ) {
    return this.coreLoopService.purchaseShopOffer(user.id, offerId, body?.source);
  }

  @Get("notifications/plan")
  async getNotificationPlan(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getNotificationPlan(user.id);
  }

  @Post("verified-inputs/completions")
  @HttpCode(200)
  async ingestVerifiedCompletion(
    @CurrentUser() user: { id: string },
    @Body()
    body: {
      sourceEventId: string;
      sourceType: "healthkit";
      sourceDomain: "workout" | "steps" | "sleep";
      vowId: string;
      localDate: string;
      progressState?: "partial" | "complete";
      quantity?: number | null;
      durationMinutes?: number | null;
    }
  ) {
    return this.coreLoopService.ingestVerifiedCompletion(user.id, body);
  }
}
