import { Module } from '@nestjs/common';
import { FrameworksService } from './frameworks.service';
import { FrameworksController } from './frameworks.controller';
import { DatabaseModule } from 'src/database.module';

@Module({
  imports: [DatabaseModule],
  controllers: [FrameworksController],
  providers: [FrameworksService]
})
export class FrameworksModule {}
