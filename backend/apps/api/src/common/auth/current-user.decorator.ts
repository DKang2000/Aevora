import { createParamDecorator, ExecutionContext } from "@nestjs/common";

export const CurrentUser = createParamDecorator((_: unknown, context: ExecutionContext): { id: string } => {
  const request = context.switchToHttp().getRequest<{ user: { id: string } }>();
  return request.user;
});
