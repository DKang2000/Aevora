import { Controller, Delete, Get, Headers, HttpCode, Post, UseGuards } from "@nestjs/common";

import { CurrentUser } from "../common/auth/current-user.decorator";
import { AuditLogService } from "../common/audit/audit-log.service";
import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller("account")
@UseGuards(SessionAuthGuard)
export class AccountController {
  constructor(
    private readonly coreLoopService: CoreLoopService,
    private readonly auditLogService: AuditLogService
  ) {}

  @Get()
  async getAccountSummary(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getAccountSummary(user.id);
  }

  @Post("export")
  @HttpCode(200)
  async requestExport(@CurrentUser() user: { id: string }, @Headers("x-request-id") requestId?: string) {
    const response = await this.coreLoopService.requestAccountExport(user.id);
    this.auditLogService.record({
      scope: "account",
      action: "prepare_export",
      actorType: "user",
      actorId: user.id,
      requestId
    });
    return response;
  }

  @Delete()
  @HttpCode(200)
  async deleteAccount(@CurrentUser() user: { id: string }, @Headers("x-request-id") requestId?: string) {
    const response = await this.coreLoopService.deleteAccount(user.id);
    this.auditLogService.record({
      scope: "account",
      action: "delete_account",
      actorType: "user",
      actorId: user.id,
      requestId,
      metadata: {
        status: "deleted"
      }
    });
    return response;
  }
}
