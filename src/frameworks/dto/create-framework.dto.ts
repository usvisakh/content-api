import { IsNotEmpty, IsNumber, IsOptional, IsString } from "class-validator";

export class CreateFrameworkDto {
    @IsString()
    @IsNotEmpty()
    name: string;
  
    @IsString()
    @IsNotEmpty()
    nativeidregex: string;
  
    @IsString()
    @IsNotEmpty()
    type: string;
  
    @IsString()
    @IsNotEmpty()
    source: string;
  
    @IsOptional()
    @IsString()
    notes?: string;
  
    @IsString()
    @IsNotEmpty()
    createdby: string;
  
    @IsNumber()
    @IsNotEmpty()
    refstatustypeid: number;
  }
