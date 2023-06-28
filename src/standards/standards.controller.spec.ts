import { Test, TestingModule } from '@nestjs/testing';
import { StandardsController } from './standards.controller';
import { StandardsService } from './standards.service';

describe('StandardsController', () => {
  let controller: StandardsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [StandardsController],
      providers: [StandardsService],
    }).compile();

    controller = module.get<StandardsController>(StandardsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
