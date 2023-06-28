import { ApiProperty, PartialType } from '@nestjs/swagger';
//import { CreateAssetDto } from './create-asset.dto';

//export class UpdateAssetDto extends PartialType(CreateAssetDto) {}


export class UpdateAssetDto {
    @ApiProperty({ example: 'Asset Title' })
    title?: string;
  
    @ApiProperty({ example: 'en-US' })
    language?: string;
  
    @ApiProperty({ example: 1 })
    version?: number;
  
    @ApiProperty({ example: 'Item Body' })
    itemBody?: string;
  
    @ApiProperty({ example: 'Response Processing' })
    responseProcessing?: string;
  
    @ApiProperty({ example: 'qti' })
    qtiFormat?: string;
  
    @ApiProperty({ example: '2022-01-01' })
    finalizedOn?: Date;
  
    @ApiProperty({ example: 'user@example.com' })
    finalizedBy?: string;
  
    @ApiProperty({ example: { key: 'value' } })
    metadata?: object;

    @ApiProperty({ example: 'user@example.com' })
    updatedBy?: string;
  
    @ApiProperty({ example: 1 })
    refStatusTypeId?: number;
  
    @ApiProperty({ example: 1 })
    refAssetTypeId?: number;
  
    @ApiProperty({ example: { key: 'value' } })
    markups?: object;
  }