//
//  CQURL.m
//  financeCompany
//
//  Created by runo on 16/5/18.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQURL.h"
#import "SBJson.h"
@implementation CQURL

+(NSString *)getPostURL{
    
    return ServerUrl;
    //return [NSString stringWithFormat:@"%@%@",ServerUrl,@"Ajax/phoneAPI.ashx"];
}


+(id)FromJson:(NSString*)jsonStr
{
    SBJsonParser * parser=[[SBJsonParser alloc] init];
    id jsonValue=[parser objectWithString:jsonStr];
    return jsonValue;
}

+(NSString*)FromJsonStr:(NSString*)jsonStr
{
    SBJsonParser * parser=[[SBJsonParser alloc] init];
    NSString* jsonValue=[parser objectWithString:jsonStr];
    return jsonValue;
}

+(NSString *) ToJson:(id) obj{
    //NSString *value = nil;//cq@""
    NSString *value = @"\"\"";//cq
    if (!obj) {
        return value;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:obj];
    }else if([obj isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:obj];
    }else if([obj isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:obj];
    }else if ([obj isKindOfClass:[NSNumber class]]){
        value = [self jsonStringWithString:[(NSNumber *)obj stringValue]];
    }
    return value;
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self ToJson:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self ToJson:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

/*
+(showInfo*)showLoding:(NSString *)message TargetView:(UIView*)view
{
    showInfo * userinfo=[showInfo shareinfomation];
    [userinfo showLoading:message Target:view];
    return userinfo;
}
+(void)hideLoading:(showInfo*)info
{
    if (info!=nil) {
        [info.hud hide:YES];
    }
}
 */

@end
