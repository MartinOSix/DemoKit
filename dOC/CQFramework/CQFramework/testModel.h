//
//  testModel.h
//  CQFramework
//
//  Created by runo on 17/2/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQDBOperator.h"
@interface testModel : NSObject <CQDBOperatorSettingInterface>

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *age;
@property(atomic,copy) NSString *copystr;
@property(nonatomic,assign) NSInteger height;
@property(nonatomic,readonly,copy) NSString *haha;


@end
