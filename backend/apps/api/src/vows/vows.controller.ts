import { Body, Controller, Get, Param, Patch, Post, UseGuards } from "@nestjs/common";

import { CurrentUser } from "../common/auth/current-user.decorator";
import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller("vows")
@UseGuards(SessionAuthGuard)
export class VowsController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Get()
  async listVows(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.listVows(user.id);
  }

  @Post()
  async createVow(@CurrentUser() user: { id: string }, @Body() body: Record<string, unknown>) {
    return this.coreLoopService.createVow(user.id, body as never);
  }

  @Patch(":vowId")
  async updateVow(@CurrentUser() user: { id: string }, @Param("vowId") vowId: string, @Body() body: Record<string, unknown>) {
    return this.coreLoopService.updateVow(user.id, vowId, body as never);
  }

  @Post(":vowId/archive")
  async archiveVow(@CurrentUser() user: { id: string }, @Param("vowId") vowId: string) {
    return this.coreLoopService.archiveVow(user.id, vowId);
  }
}
