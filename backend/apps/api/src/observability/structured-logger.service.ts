import { Injectable, Logger } from "@nestjs/common";

export interface StructuredLogEntry {
  level: "info" | "warn" | "error";
  message: string;
  context?: string;
  metadata?: Record<string, unknown>;
}

@Injectable()
export class StructuredLoggerService {
  private readonly logger = new Logger("AevoraApi");
  private readonly entries: StructuredLogEntry[] = [];

  info(message: string, metadata?: Record<string, unknown>, context?: string): void {
    this.entries.unshift({ level: "info", message, metadata, context });
    this.logger.log({ message, metadata, context });
  }

  warn(message: string, metadata?: Record<string, unknown>, context?: string): void {
    this.entries.unshift({ level: "warn", message, metadata, context });
    this.logger.warn({ message, metadata, context });
  }

  error(message: string, metadata?: Record<string, unknown>, context?: string): void {
    this.entries.unshift({ level: "error", message, metadata, context });
    this.logger.error({ message, metadata, context });
  }

  recent(): StructuredLogEntry[] {
    return [...this.entries];
  }
}
