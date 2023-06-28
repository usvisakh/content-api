import { Controller, Get, Post, Body, Patch, Param, Delete, Query, HttpException, HttpStatus } from '@nestjs/common';
import { StandardsService } from './standards.service';
import { CreateStandardDto } from './dto/create-standard.dto';
import { UpdateStandardDto } from './dto/update-standard.dto';
import { ApiQuery, ApiTags } from '@nestjs/swagger';

export enum SortBy {
  ASC = 'ASC',
  DESC = 'DESC'
}

@Controller({
  version: '1',
  path: 'standards'
})
@ApiTags('standards')
export class StandardsController {
  constructor(private readonly standardsService: StandardsService) {}

  @Post()
  create(@Body() createStandardDto: CreateStandardDto) {
    return this.standardsService.create(createStandardDto);
  }

  @Get()
  @ApiQuery({ name: 'page', description: 'Page number', required: false, type: 'integer'})
  @ApiQuery({ name: 'limit', description: 'Number of items per page', required: false, type: 'integer' })
  @ApiQuery({ name: 'sort', description: 'Field to sort by', required: false, type: 'string' })
  @ApiQuery({ name: 'order', description: 'Sorting order (ASC or DESC)', required: false, enum: SortBy })
  findAll(@Query('page') page:number = 1, @Query('limit') limit:number = 10, @Query('sort') sort:string = 'standardid', @Query('order') order:string = 'ASC') {
    return this.standardsService.findAll(page, limit, sort, order);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const result = await this.standardsService.findOne(+id);

    if (!result) {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }
    return result;
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateStandardDto: UpdateStandardDto) {
    return this.standardsService.update(+id, updateStandardDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.standardsService.remove(+id);
  }
}
