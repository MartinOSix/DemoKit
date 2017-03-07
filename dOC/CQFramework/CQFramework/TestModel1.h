//
//  TestModel1.h
//  CQFramework
//
//  Created by runo on 17/2/28.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HahaABC.h"
#import "CQDBOperatorSettingInterface.h"
@interface TestModel1 : NSObject <CQDBOperatorSettingInterface>

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)HahaABC *haha;


@end
