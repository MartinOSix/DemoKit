//
//  CQNUD.h
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQNUD : NSObject

+(void)cqSetObj:(id)object Key:(NSString *)key;
+(id)cqGetObjForKey:(NSString *)key;

+(void)cqWriteInt:(NSInteger )value Key:(NSString *)key;
+(void)cqWriteBool:(BOOL)value Key:(NSString *)key;

+(NSInteger)cqReadIntWithKey:(NSString *)key;
+(BOOL)cqReadBoolWithKey:(NSString *)key;
+(BOOL)cqRemoveValueFromKey:(NSString *)key;

@end
