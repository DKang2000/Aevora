import { Body, Controller, Get, Patch, UseGuards } from "@nestjs/common";

import { CurrentUser } from "../common/auth/current-user.decorator";
import { SessionAuthGuard } from "../common/auth/session-auth.guard";
import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller()
@UseGuards(SessionAuthGuard)
export class ProfileController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Get("profile")
  async getProfile(@CurrentUser() user: { id: string }) {
    return this.coreLoopService.getProfile(user.id);
  }

  @Patch("profile")
  async updateProfile(@CurrentUser() user: { id: string }, @Body() body: Record<string, unknown>) {
    return this.coreLoopService.updateProfile(user.id, body);
  }

  @Patch("avatar")
  async updateAvatar(@CurrentUser() user: { id: string }, @Body() body: Record<string, unknown>) {
    return this.coreLoopService.updateAvatar(user.id, body);
  }
}
