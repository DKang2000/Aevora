import { CanActivate, ExecutionContext, Injectable } from "@nestjs/common";

import { CoreLoopService } from "../../core-loop/core-loop.service";

@Injectable()
export class SessionAuthGuard implements CanActivate {
  constructor(private readonly coreLoopService: CoreLoopService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<{ headers: Record<string, string>; user?: { id: string } }>();
    const player = await this.coreLoopService.resolvePlayer(request.headers.authorization);
    request.user = {
      id: player.user.id
    };
    return true;
  }
}
