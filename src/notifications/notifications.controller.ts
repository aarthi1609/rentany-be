import { Controller, Get } from '@nestjs/common';

@Controller('notifications')
export class NotificationsController {
  @Get()
  listNotifications() {
    return undefined;
  }
}
