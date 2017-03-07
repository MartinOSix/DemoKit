//
//  CQDBOperatorSettingInterface.h
//  CQFramework
//
//  Created by runo on 17/2/28.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CQDBOperatorSettingInterface <NSObject>

@required
/**表格式*/
+ (float)cqTableVersion;

@optional
/**是否是主键*/
+ (BOOL)cqIsPrimaryKey:(NSString *)property;
/**是否为空*/
+ (BOOL)cqIsAllowNull:(NSString *)property;
/**是否忽略属性*/
+ (BOOL)cqIsIgnoreProperty:(NSString *)property;

@end
