import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';

import { CreateRentalDto } from './dto/create-rental.dto';
import { CreateRentalMessageDto } from './dto/create-rental-message.dto';
import { UpdateRentalStatusDto } from './dto/update-rental-status.dto';
import { RentalsService } from './rentals.service';

@Controller('rentals')
export class RentalsController {
  constructor(private readonly rentalsService: RentalsService) {}

  @Get()
  listRentals() {
    return this.rentalsService.list();
  }

  @Post()
  createRental(@Body() body: CreateRentalDto) {
    return this.rentalsService.create(body);
  }

  @Patch(':id/status')
  updateRentalStatus(@Param('id') id: string, @Body() body: UpdateRentalStatusDto) {
    return this.rentalsService.updateStatus(id, body.status);
  }

  @Get(':id/messages')
  listMessages(@Param('id') id: string) {
    return this.rentalsService.listMessages(id);
  }

  @Post(':id/messages')
  addMessage(@Param('id') id: string, @Body() body: CreateRentalMessageDto) {
    return this.rentalsService.addMessage(id, body);
  }
}
