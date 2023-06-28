import { Module } from '@nestjs/common';
import { StandardsService } from './standards.service';
import { StandardsController } from './standards.controller';
import { DatabaseModule } from 'src/database.module';
import { FrameworksService } from 'src/frameworks/frameworks.service';

@Module({
  imports: [DatabaseModule],
  controllers: [StandardsController],
  providers: [StandardsService, FrameworksService]
})
export class StandardsModule {}
