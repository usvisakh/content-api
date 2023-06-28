export interface Framework {
    frameworkid: number;
    name: string;
    nativeidregex: string;
    type: string;
    source: string;
    notes?: string;
    createdon: Date;
    createdby: string;
    updatedon?: Date;
    updatedby?: string;
    refstatustypeid: number;
  }