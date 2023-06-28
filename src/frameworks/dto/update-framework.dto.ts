import { IsNumber, IsOptional, IsString } from "class-validator";

export class UpdateFrameworkDto {
    @IsOptional()
    @IsString()
    name?: string;
  
    @IsOptional()
    @IsString()
    nativeidregex?: string;
  
    @IsOptional()
    @IsString()
    type?: string;
  
    @IsOptional()
    @IsString()
    source?: string;
  
    @IsOptional()
    @IsString()
    notes?: string;
  
    @IsOptional()
    @IsString()
    updatedby?: string;
  
    @IsOptional()
    @IsNumber()
    refstatustypeid?: number;
  }