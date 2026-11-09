import { Injectable } from '@nestjs/common';

import { CreateProductDto } from './dto/create-product.dto';

@Injectable()
export class ProductsService {
  list() {
    return undefined;
  }

  create(_input: CreateProductDto) {
    return undefined;
  }

  findById(_id: string) {
    return undefined;
  }
}
