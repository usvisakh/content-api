import { Controller, Get, Post, Body, Patch, Param, Delete, HttpStatus, HttpException, Query } from '@nestjs/common';
import { FrameworksService } from './frameworks.service';
import { CreateFrameworkDto } from './dto/create-framework.dto';
import { UpdateFrameworkDto } from './dto/update-framework.dto';
import { ApiQuery, ApiTags } from '@nestjs/swagger';

export enum SortBy {
  ASC = 'ASC',
  DESC = 'DESC'
}

@Controller({
  version: '1',
  path: 'frameworks'
})
@ApiTags('frameworks')
export class FrameworksController {
  constructor(private readonly frameworksService: FrameworksService) {}

  @Post()
  create(@Body() createFrameworkDto: CreateFrameworkDto) {
    return this.frameworksService.create(createFrameworkDto);
  }

  @Get()
  @ApiQuery({ name: 'page', description: 'Page number', required: false, type: 'integer'})
  @ApiQuery({ name: 'limit', description: 'Number of items per page', required: false, type: 'integer' })
  @ApiQuery({ name: 'sort', description: 'Field to sort by', required: false, type: 'string' })
  @ApiQuery({ name: 'order', description: 'Sorting order (ASC or DESC)', required: false, enum: SortBy })
  findAll(@Query('page') page:number = 1, @Query('limit') limit:number = 10, @Query('sort') sort:string = 'frameworkid', @Query('order') order:string = 'ASC') {
    return this.frameworksService.findAll(page, limit, sort, order);
  }

  @Get(':id')
  async findOne(@Param('id') id: number) {
    const result = await this.frameworksService.findOne(+id);

    if (!result) {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }
    return result;
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateFrameworkDto: UpdateFrameworkDto) {
    const result = await this.frameworksService.findOne(+id);

    if (!result) {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }

    return this.frameworksService.update(+id, updateFrameworkDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: number) {
    const result = await this.frameworksService.delete(+id);
    if (!result) {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }
    return result;
  }
}
