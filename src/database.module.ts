import { Logger, Module, OnApplicationShutdown } from '@nestjs/common';
import { Pool } from 'pg';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { DatabaseService } from './database.service';
import { ModuleRef } from '@nestjs/core';

@Module({
    imports: [ConfigModule],
    providers: [
      {
        provide: 'DATABASE_POOL',
        useFactory: async (configService: ConfigService) =>
          new Pool({
            host: configService.get('DB_HOST'),
            port: configService.get<number>('DB_PORT'),
            user: configService.get('DB_USERNAME'),
            password: configService.get('DB_PASSWORD'),
            database: configService.get('DB_DATABASE')//,
            //ssl: configService.get('DB_SSL') ? { rejectUnauthorized: false } : false,
          }),
        inject: [ConfigService],
      },
      DatabaseService
    ],
    exports: [DatabaseService],
  })
  export class DatabaseModule implements OnApplicationShutdown {
    private readonly logger = new Logger(DatabaseModule.name);
  
    constructor(private readonly moduleRef: ModuleRef) {}
  
    onApplicationShutdown(signal?: string): any {
      this.logger.log(`Shutting down on signal ${signal}`);

      const pool = this.moduleRef.get('DATABASE_POOL') as Pool;
      return pool.end();

    }
  }