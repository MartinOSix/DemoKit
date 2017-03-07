//
//  HahaABC.h
//  CQFramework
//
//  Created by runo on 17/2/28.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQDBOperatorSettingInterface.h"
@interface HahaABC : NSObject <CQDBOperatorSettingInterface,NSCoding>

@property(nonatomic,strong)NSString *order;
@property(nonatomic,strong)NSString *haha;

@end
