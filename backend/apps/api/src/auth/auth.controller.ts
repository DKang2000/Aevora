import { Body, Controller, HttpCode, Post } from "@nestjs/common";

import { CoreLoopService } from "../core-loop/core-loop.service";

@Controller("auth")
export class AuthController {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  @Post("guest")
  @HttpCode(200)
  async createGuestSession(@Body() body: { deviceId: string }) {
    return this.coreLoopService.createGuestSession(body.deviceId);
  }

  @Post("apple")
  @HttpCode(200)
  async createAppleSession(@Body() body: { identityToken: string }) {
    return this.coreLoopService.createAppleSession(body.identityToken);
  }

  @Post("link-account")
  @HttpCode(200)
  async linkAccount(@Body() body: { guestUserId: string; identityToken: string }) {
    return this.coreLoopService.linkAccount(body.guestUserId, body.identityToken);
  }

  @Post("restore-session")
  @HttpCode(200)
  async restoreSession(@Body() body: { refreshToken: string }) {
    return this.coreLoopService.restoreSession(body.refreshToken);
  }
}
