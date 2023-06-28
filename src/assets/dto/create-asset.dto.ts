import { ApiProperty } from '@nestjs/swagger';

export class CreateAssetDto {
  @ApiProperty({ example: 'Asset Title' })
  title: string;

  @ApiProperty({ example: 'en-US' })
  language: string;

  @ApiProperty({ example: 'asset-123' })
  displayId: string;

  @ApiProperty({ example: 1 })
  version: number;

  @ApiProperty({ example: 'Item Body', type: 'xml' })
  itemBody: string;

  @ApiProperty({ example: 'Response Processing', type: 'xml' })
  responseProcessing?: string;

  @ApiProperty({ example: 'qti' })
  qtiFormat: string;

  @ApiProperty({ example: { key: 'value' }, type: 'json' })
  metadata?: object;

  @ApiProperty({ example: 'user@example.com' })
  createdBy: string;

  @ApiProperty({ example: 1 })
  refStatusTypeId: number;

  @ApiProperty({ example: 1 })
  refAssetTypeId: number;

  @ApiProperty({ example: { key: 'value' } })
  markups?: object;
}