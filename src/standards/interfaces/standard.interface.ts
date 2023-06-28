import { Framework } from "src/frameworks/interfaces/framework.interface";

export interface Standard {
  standardid: number;
  uniqueid: string;
  nativeid: string;
  notes?: string;
  isleaf: boolean;
  createdon: Date;
  createdby: string;
  updatedon?: Date;
  updatedby?: string;
  refstatustypeid: number;
  framework: Framework; // Updated property
}
