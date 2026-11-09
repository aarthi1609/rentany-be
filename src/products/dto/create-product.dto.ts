import { IsNumber, IsOptional, IsString, IsUUID, Min } from 'class-validator';

export class CreateProductDto {
  @IsUUID()
  ownerId: string;

  @IsUUID()
  categoryId: string;

  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  model?: string;

  @IsOptional()
  @IsString()
  imageS3Key?: string;

  @IsNumber()
  @Min(1)
  pricePerDay: number;

  @IsOptional()
  @IsString()
  city?: string;

  @IsOptional()
  @IsNumber()
  latitude?: number;

  @IsOptional()
  @IsNumber()
  longitude?: number;
}
