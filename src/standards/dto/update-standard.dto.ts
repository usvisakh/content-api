export class UpdateStandardDto {
    uniqueid?: string;
    nativeid?: string;
    notes?: string;
    isleaf?: boolean;
    updatedby: string;
    refstatustypeid?: number;
    frameworkid?: number;
  }