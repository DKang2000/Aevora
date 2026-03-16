import { Controller, Delete, Get, HttpCode, Post, UseGuards } from "@nestjs/common";

import { CurrentUser } from "../common/auth/current-user.decorator";
import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller("account")
@UseGuards(SessionAuthGuard)
export class AccountController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Get()
  async getAccountSummary(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getAccountSummary(user.id);
  }

  @Post("export")
  @HttpCode(200)
  async requestExport(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.requestAccountExport(user.id);
  }

  @Delete()
  @HttpCode(200)
  async deleteAccount(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.deleteAccount(user.id);
  }
}
