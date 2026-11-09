import { Module } from '@nestjs/common';

import { HealthController } from './health/health.controller';
import { NotificationsController } from './notifications/notifications.controller';
import { ProductsController } from './products/products.controller';
import { ProductsService } from './products/products.service';
import { RentalsController } from './rentals/rentals.controller';
import { RentalsService } from './rentals/rentals.service';

@Module({
  controllers: [
    HealthController,
    ProductsController,
    RentalsController,
    NotificationsController
  ],
  providers: [ProductsService, RentalsService]
})
export class AppModule {}
