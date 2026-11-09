import { IsIn } from 'class-validator';

export class UpdateRentalStatusDto {
  @IsIn(['requested', 'accepted', 'rejected', 'cancelled', 'in_progress', 'returned', 'completed'])
  status: string;
}
