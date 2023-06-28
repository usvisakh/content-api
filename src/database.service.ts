import { Inject, Injectable, Logger } from '@nestjs/common';
import { Pool, PoolClient, QueryResult } from 'pg';

@Injectable()
export class DatabaseService {
  private readonly logger = new Logger(DatabaseService.name);

  constructor(@Inject('DATABASE_POOL') private pool: Pool) {}

  async executeQuery(queryText: string, values: any[] = []): Promise<any[]> {
    this.logger.debug(`Executing query: ${queryText} (${values})`);

    const result = await this.pool.query(queryText, values);
    this.logger.debug(`Executed query, result size ${result.rows.length}`);
    return result.rows;
  }

  async executeNonQuery(queryText: string, values: any[] = []): Promise<any> {
    this.logger.debug(`Executing non query: ${queryText} (${values})`);

    const result = await this.pool.query(queryText, values);
    this.logger.debug(`Executed non query, rows affected ${result.rowCount}`);
    return result;
  }
}