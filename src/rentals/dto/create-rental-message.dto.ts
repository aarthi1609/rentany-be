import { IsBoolean, IsOptional, IsString, IsUUID } from 'class-validator';

export class CreateRentalMessageDto {
  @IsUUID()
  senderId: string;

  @IsString()
  message: string;

  @IsOptional()
  @IsBoolean()
  isSystemMessage?: boolean;
}
