import { Injectable, OnModuleDestroy, OnModuleInit } from "@nestjs/common";
import { PrismaClient } from "@prisma/client";

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private shouldConnect(): boolean {
    return process.env.CORE_LOOP_PERSISTENCE === "prisma";
  }

  async onModuleInit(): Promise<void> {
    if (this.shouldConnect()) {
      await this.$connect();
    }
  }

  async onModuleDestroy(): Promise<void> {
    if (this.shouldConnect()) {
      await this.$disconnect();
    }
  }
}
