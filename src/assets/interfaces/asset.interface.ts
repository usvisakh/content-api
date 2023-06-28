export interface Asset {
    assetId: number;
    uniqueId: string;
    title: string;
    language: string;
    displayId: string;
    version: number;
    itemBody: string;
    responseProcessing?: string;
    qtiFormat: string;
    finalizedOn?: Date;
    finalizedBy?: string;
    metadata?: object;
    createdOn: Date;
    createdBy: string;
    updatedOn?: Date;
    updatedBy?: string;
    refStatusTypeId: number;
    refAssetTypeId: number;
    markups?: object;
  }