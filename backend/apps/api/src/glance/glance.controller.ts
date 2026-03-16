import { Controller, Get, UseGuards } from "@nestjs/common";

import { CurrentUser } from "../common/auth/current-user.decorator";
import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller("glance")
@UseGuards(SessionAuthGuard)
export class GlanceController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Get("state")
  async getGlanceState(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getGlanceState(user.id);
  }
}
