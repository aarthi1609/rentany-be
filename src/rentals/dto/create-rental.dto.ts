import { IsDateString, IsNumber, IsUUID, Min } from 'class-validator';

export class CreateRentalDto {
  @IsUUID()
  productId: string;

  @IsUUID()
  ownerId: string;

  @IsUUID()
  renterId: string;

  @IsDateString()
  startDate: string;

  @IsDateString()
  endDate: string;

  @IsNumber()
  @Min(0)
  totalPrice: number;
}
