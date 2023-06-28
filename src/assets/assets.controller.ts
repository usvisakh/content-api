import { Controller, Get, Post, Body, Patch, Param, Delete, HttpException, HttpStatus, Query } from '@nestjs/common';
import { AssetsService } from './assets.service';
import { CreateAssetDto } from './dto/create-asset.dto';
import { UpdateAssetDto } from './dto/update-asset.dto';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';

export enum SortBy {
  ASC = 'ASC',
  DESC = 'DESC'
}


@Controller({
  version: '1',
  path: 'assets'
})
@ApiTags('assets')
export class AssetsController {
  constructor(private readonly assetsService: AssetsService) {}

  @Post()
  @ApiOperation({ summary: 'Create an asset', operationId: 'post' })
  async create(@Body() createAssetDto: CreateAssetDto) {
    return await this.assetsService.create(createAssetDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get a list of assets', operationId: 'get' })
  @ApiQuery({ name: 'page', description: 'Page number', required: false, type: 'integer'})
  @ApiQuery({ name: 'limit', description: 'Number of items per page', required: false, type: 'integer' })
  @ApiQuery({ name: 'sort', description: 'Field to sort by', required: false, type: 'string' })
  @ApiQuery({ name: 'order', description: 'Sorting order (ASC or DESC)', required: false, enum: SortBy })
  async find(@Query('page') page = 1, @Query('limit') limit = 10, @Query('sort') sort = 'AssetId', @Query('order') order = 'ASC') {
    return this.assetsService.findAll(page, limit, sort, order);
  }

  @ApiOperation({ summary: 'Get an asset', operationId: 'get-one' })
  @Get(':id')
  async findOne(@Param('id') id: number) {
    const result = await this.assetsService.findOne(+id);

    if (result.length === 0) {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }
    return result;
  }

  @ApiOperation({ summary: 'Update an asset', operationId: 'patch' })
  @Patch(':id')
  async update(@Param('id') id: number, @Body() updateAssetDto: UpdateAssetDto) {
    const result = await this.assetsService.findOne(+id);

    if (result.length === 0) {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }


    return await this.assetsService.update(+id, updateAssetDto);
  }

  @ApiOperation({ summary: 'Delete an asset', operationId: 'delete' })
  @Delete(':id')
  async remove(@Param('id') id: number) {
    const result = await this.assetsService.remove(+id);
    if (result === 0) {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }
    return result;
  }
}

