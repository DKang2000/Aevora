import { Module } from "@nestjs/common";

import { AuditModule } from "../audit/audit.module";
import { AdminRoleGuard } from "./admin-role.guard";
import { RateLimitService } from "./rate-limit.service";

@Module({
  imports: [AuditModule],
  providers: [AdminRoleGuard, RateLimitService],
  exports: [AdminRoleGuard, RateLimitService, AuditModule]
})
export class SecurityModule {}
