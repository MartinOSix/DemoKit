//
//  TestDBOViewController.m
//  CQFramework
//
//  Created by runo on 17/2/28.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "TestDBOViewController.h"
#import "testModel.h"
#import "CQDBOperator.h"
#import "TestModel1.h"
@interface TestDBOViewController ()

@end

@implementation TestDBOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CQDBOperator cqShareDMOperation] cqRegisterClass:[TestModel1 class]];
    [self testAddModel];
    [self testDeleteModel];
    [self testGetAllModel];
}

-(void)testAddModel{
    
    NSMutableArray<CQDBOperatorSettingInterface> *marr = [[NSMutableArray<CQDBOperatorSettingInterface> alloc]init];
    for (int i = 0; i < 10; i++) {
        TestModel1 *model = [[TestModel1 alloc] init];
        model.name = [NSString stringWithFormat:@"name_%d",i];
        model.sex = [NSString stringWithFormat:@"age_%d",i];
        [marr addObject:model];
    }
    
    [[CQDBOperator cqShareDMOperation] cqSaveAllModel:marr];
}

-(void)testDeleteModel{
    
    [[CQDBOperator cqShareDMOperation] cqDeleteModelWhere:@{@"name":@"name_5"} AtClass:[TestModel1 class]];
    
}

-(void)testGetAllModel{
    NSArray *arr = [[CQDBOperator cqShareDMOperation]cqGetAllModel:[TestModel1 class]];
    NSLog(@"%@",arr);
}

@end
