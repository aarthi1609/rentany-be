import { Injectable } from '@nestjs/common';

import { CreateRentalDto } from './dto/create-rental.dto';
import { CreateRentalMessageDto } from './dto/create-rental-message.dto';

@Injectable()
export class RentalsService {
  list() {
    return undefined;
  }

  create(_input: CreateRentalDto) {
    return undefined;
  }

  updateStatus(_id: string, _status: string) {
    return undefined;
  }

  listMessages(_rentalId: string) {
    return undefined;
  }

  addMessage(_rentalId: string, _input: CreateRentalMessageDto) {
    return undefined;
  }
}
