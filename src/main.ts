import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { SwaggerModule } from '@nestjs/swagger';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import 'reflect-metadata';
import { parse } from 'yaml';

import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api');
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true
    })
  );

  const openApiPath = join(process.cwd(), 'openapi', 'rentany.yaml');
  const openApiDocument = parse(readFileSync(openApiPath, 'utf8'));
  SwaggerModule.setup('docs', app, openApiDocument);

  const port = Number(process.env.PORT ?? 3000);
  await app.listen(port);
}

void bootstrap();
