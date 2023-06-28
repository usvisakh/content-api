import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AssetsModule } from './assets/assets.module';
import { ConfigModule } from '@nestjs/config'
import { FrameworksModule } from './frameworks/frameworks.module';
import { StandardsModule } from './standards/standards.module';

@Module({
  imports: [AssetsModule, FrameworksModule, StandardsModule,
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['env/.env'],
    })    
  ],
  controllers: [AppController],
  providers: [AppService]
})
export class AppModule {}
