import { Injectable } from '@nestjs/common';
import { Pool } from 'pg';
import { Framework } from './interfaces/framework.interface';
import { DatabaseService } from 'src/database.service';
import { CreateFrameworkDto } from './dto/create-framework.dto';
import { UpdateFrameworkDto } from './dto/update-framework.dto';

@Injectable()
export class FrameworksService {
  constructor(private readonly dbService: DatabaseService) {}

  async findAll(page = 1, limit = 10, sort = 'frameworkid', order = 'ASC'): Promise<any> {
    const offset = (page - 1) * limit;

    const frameworks = await this.dbService.executeQuery(`SELECT * FROM frameworks ORDER BY ${sort} ${order} LIMIT ${limit} OFFSET ${offset}`);

    const total = await this.dbService.executeQuery('SELECT COUNT(1) FROM frameworks');

    return {
      data: frameworks,
      page,
      limit,
      total: parseInt(total[0].count, 10),
    };
  }

  async findOne(id: number): Promise<Framework> {
    const result = await this.dbService.executeQuery('SELECT * FROM frameworks WHERE frameworkid = $1', [id]);
    return result[0];
  }

  async create(framework: CreateFrameworkDto): Promise<Framework> {
    const columns = [];
    const values = [];
    const params = [];
    let i = 1;

    // Loop through each property of the CreateAssetDto
    for (const [key, value] of Object.entries(framework)) {
      if (value !== null && value !== undefined) {
        columns.push(key);
        values.push(value);

        params.push(`$${i}`);
        i++;
      }
    }

    const queryString = `INSERT INTO frameworks (${columns.join(', ')}) VALUES (${params.join(', ')}) RETURNING *`;
    const result = await this.dbService.executeQuery(queryString, values);

    return result[0];
  
  }

  async update(id: number, updatedFramework: UpdateFrameworkDto): Promise<Framework> {
    const updates = [];
    const values = [];
    let i = 1;

    for (const [key, value] of Object.entries(updatedFramework)) {
      if (value !== null && value !== undefined) {
        updates.push(`${key} = $${i}`);
        values.push(value);

        i++;
      }
    }

    // Add the updatedOn timestamp to the updates and values arrays
    updates.push('updatedOn = clock_timestamp()');
    values.push(id);

    const queryString = `UPDATE frameworks SET ${updates.join(', ')} WHERE frameworkid = $${i} RETURNING *`;
    const result = await this.dbService.executeQuery(queryString, values);

    return result[0];

  }

  async delete(id: number): Promise<boolean> {
    const result = await this.dbService.executeNonQuery('DELETE FROM frameworks WHERE frameworkid = $1', [id]);
    return result.rowCount > 0;
  }
}
