import { Controller, Get, Headers, UseGuards } from "@nestjs/common";

import { AdminRoleGuard } from "../security/admin-role.guard";
import { AuditLogService } from "./audit-log.service";

@Controller("audit")
export class AuditController {
  constructor(private readonly auditLogService: AuditLogService) {}

  @Get("admin")
  @UseGuards(AdminRoleGuard)
  getAuditEntries(@Headers("x-request-id") requestId?: string): Record<string, unknown> {
    return {
      requestId: requestId ?? null,
      entries: this.auditLogService.list()
    };
  }
}
