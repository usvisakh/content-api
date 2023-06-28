import { Injectable } from '@nestjs/common';
import { Pool } from 'pg';
import { Standard } from './interfaces/standard.interface';
import { Framework } from 'src/frameworks/interfaces/framework.interface';
import { UpdateStandardDto } from './dto/update-standard.dto';
import { CreateStandardDto } from './dto/create-standard.dto';
import { DatabaseService } from 'src/database.service';
import { FrameworksService } from 'src/frameworks/frameworks.service';

@Injectable()
export class StandardsService {
  private pool: Pool;

  constructor(private readonly dbService: DatabaseService, private readonly frameworksService: FrameworksService) {
  }

  async findAll(page = 1, limit = 10, sort = 'standardid', order = 'ASC'): Promise<any> {
    const offset = (page - 1) * limit;

    const result = await this.dbService.executeQuery(`SELECT s.*, f.* FROM standards s INNER JOIN frameworks f ON s.frameworkid = f.frameworkid ORDER BY ${sort} ${order} LIMIT ${limit} OFFSET ${offset}`);
    const total = await this.dbService.executeQuery('SELECT COUNT(1) FROM standards');

    const data = result.map(row => this.mapToStandard(row));

    return {
      data,
      page,
      limit,
      total: parseInt(total[0].count, 10),
    };
  }

  async findOne(id: number): Promise<Standard> {
    const result = await this.dbService.executeQuery('SELECT s.*, f.* FROM standards s INNER JOIN frameworks f ON s.frameworkid = f.frameworkid WHERE standardid = $1', [id]);
    if (result.length === 0) {
      return null;
    }
    return this.mapToStandard(result[0]);
  }

  async create(standardDto: CreateStandardDto): Promise<Standard> {
    const columns = [];
    const values = [];
    const params = [];
    let i = 1;

    // Loop through each property of the CreateAssetDto
    for (const [key, value] of Object.entries(standardDto)) {
      if (value !== null && value !== undefined) {
        columns.push(key);
        values.push(value);

        params.push(`$${i}`);
        i++;
      }
    }

    const query = `INSERT INTO standards (${columns.join(', ')}) VALUES (${params.join(', ')}) RETURNING *`;
    const result = await this.dbService.executeQuery(query, values);

    let standard = this.mapToStandard(result[0]);

    const framework = await this.frameworksService.findOne(standardDto.frameworkid);
    standard.framework = framework;

    return standard;
  }

  async update(id: number, updatedStandardDto: UpdateStandardDto): Promise<Standard> {
    const {
      uniqueid,
      nativeid,
      notes,
      isleaf,
      updatedby,
      refstatustypeid,
      frameworkid,
    } = updatedStandardDto;

    const query =
      'UPDATE standards SET uniqueid = $1, nativeid = $2, notes = $3, isleaf = $4, updatedby = $5, refstatustypeid = $6, frameworkid = $7, updatedon = NOW() WHERE standardid = $8 RETURNING *';
    const values = [
      uniqueid,
      nativeid,
      notes,
      isleaf,
      updatedby,
      refstatustypeid,
      frameworkid,
      id,
    ];

    const { rows } = await this.pool.query(query, values);
    return this.mapToStandard(rows[0]);
  }

  async remove(id: number): Promise<boolean> {
    const result = await this.dbService.executeNonQuery('DELETE FROM standards WHERE standardid = $1', [id]);
    return result.rowCount > 0;
  }

  private mapToStandard(row: any): Standard {
    const framework: Framework = {
      frameworkid: row.frameworkid,
      name: row.name,
      nativeidregex: row.nativeidregex,
      type: row.type,
      source: row.source,
      notes: row.notes,
      createdon: row.createdon,
      createdby: row.createdby,
      updatedon: row.updatedon,
      updatedby: row.updatedby,
      refstatustypeid: row.refstatustypeid,
    };

    const standard: Standard = {
      standardid: row.standardid,
      uniqueid: row.uniqueid,
      nativeid: row.nativeid,
      notes: row.notes,
      isleaf: row.isleaf,
      createdon: row.createdon,
      createdby: row.createdby,
      updatedon: row.updatedon,
      updatedby: row.updatedby,
      refstatustypeid: row.refstatustypeid,
      framework: framework,
    };

    return standard;
  }
}
