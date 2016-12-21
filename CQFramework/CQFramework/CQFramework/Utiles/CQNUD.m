//
//  CQNUD.m
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQNUD.h"

@implementation CQNUD

+(void)cqSetObj:(id)object Key:(NSString *)key{
    if ([object isMemberOfClass:[NSNull class]])
    {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (object != nil)
    {
        [userDefaults setObject:object forKey:key];
    }else
    {
        [userDefaults removeObjectForKey:key];
    }
    
    [userDefaults synchronize];
}
+(id)cqGetObjForKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id object = [userDefaults objectForKey:key];
    return object;
}

+(void)cqWriteInt:(NSInteger )value Key:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)cqWriteBool:(BOOL)value Key:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)cqReadIntWithKey:(NSString *)key{
    
    if (![[NSUserDefaults standardUserDefaults]integerForKey:key]) {
        return -1;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}
+(BOOL)cqReadBoolWithKey:(NSString *)key{
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:key]) {
        return false;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+(BOOL)cqRemoveValueFromKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    return [[NSUserDefaults standardUserDefaults]synchronize];
}






@end
