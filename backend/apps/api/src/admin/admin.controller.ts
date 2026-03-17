import { Body, Controller, Get, Headers, Param, Post, UseGuards } from "@nestjs/common";

import { AdminRoleGuard } from "../common/security/admin-role.guard";
import { AdminService } from "./admin.service";

@Controller("admin")
@UseGuards(AdminRoleGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get("runtime-config/releases/current")
  getRuntimeConfigReleaseState() {
    return this.adminService.getRuntimeConfigReleaseState();
  }

  @Post("runtime-config/releases/promote")
  promoteRuntimeConfig(
    @Body() body: { candidatePath: string; label: string; notes?: string },
    @Headers("x-aevora-actor-id") actorId?: string,
    @Headers("x-request-id") requestId?: string
  ) {
    return this.adminService.promoteRuntimeConfig(body, actorId ?? "admin", requestId);
  }

  @Get("content/releases/current")
  getContentReleaseState() {
    return this.adminService.getContentReleaseState();
  }

  @Post("content/releases/promote")
  promoteContent(
    @Body() body: { contentPath: string; copyPath?: string; label: string; notes?: string },
    @Headers("x-aevora-actor-id") actorId?: string,
    @Headers("x-request-id") requestId?: string
  ) {
    return this.adminService.promoteContent(body, actorId ?? "admin", requestId);
  }

  @Get("assets/releases/current")
  getAssetReleaseState() {
    return this.adminService.getAssetReleaseState();
  }

  @Post("assets/releases/promote")
  promoteAssets(
    @Body() body: { manifestPath: string; label: string; notes?: string },
    @Headers("x-aevora-actor-id") actorId?: string,
    @Headers("x-request-id") requestId?: string
  ) {
    return this.adminService.promoteAssetManifest(body, actorId ?? "admin", requestId);
  }

  @Get("accounts/:userId")
  async getAccountSummary(
    @Param("userId") userId: string,
    @Headers("x-aevora-actor-id") actorId?: string,
    @Headers("x-request-id") requestId?: string
  ) {
    return this.adminService.getAccountSummary(userId, actorId ?? "admin", requestId);
  }

  @Post("accounts/:userId/export")
  async prepareAccountExport(
    @Param("userId") userId: string,
    @Headers("x-aevora-actor-id") actorId?: string,
    @Headers("x-request-id") requestId?: string
  ) {
    return this.adminService.prepareAccountExport(userId, actorId ?? "admin", requestId);
  }
}
