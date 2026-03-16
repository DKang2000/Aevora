import { Injectable } from "@nestjs/common";
import { randomUUID } from "node:crypto";

export interface AuditEntry {
  id: string;
  scope: string;
  action: string;
  actorType: string;
  actorId?: string;
  requestId?: string;
  metadata?: Record<string, unknown>;
  createdAt: string;
}

@Injectable()
export class AuditLogService {
  private readonly entries: AuditEntry[] = [];

  record(entry: Omit<AuditEntry, "id" | "createdAt">): AuditEntry {
    const nextEntry: AuditEntry = {
      id: randomUUID(),
      createdAt: new Date().toISOString(),
      ...entry
    };

    this.entries.unshift(nextEntry);
    return nextEntry;
  }

  list(): AuditEntry[] {
    return [...this.entries];
  }
}
