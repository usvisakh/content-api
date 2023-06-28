import { Test, TestingModule } from '@nestjs/testing';
import { FrameworksController } from './frameworks.controller';
import { FrameworksService } from './frameworks.service';

describe('FrameworksController', () => {
  let controller: FrameworksController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [FrameworksController],
      providers: [FrameworksService],
    }).compile();

    controller = module.get<FrameworksController>(FrameworksController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
