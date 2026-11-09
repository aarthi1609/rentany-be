import { Body, Controller, Get, Param, Post } from '@nestjs/common';

import { CreateProductDto } from './dto/create-product.dto';
import { ProductsService } from './products.service';

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  listProducts() {
    return this.productsService.list();
  }

  @Post()
  createProduct(@Body() body: CreateProductDto) {
    return this.productsService.create(body);
  }

  @Get(':id')
  getProduct(@Param('id') id: string) {
    return this.productsService.findById(id);
  }
}
