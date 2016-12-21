//
//  CQJSONParser.m
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQJSONParser.h"
#import "CQConstantDefine.h"

@implementation CQJSONParser

+(id)objFromJsonString:(NSString *)jsonString{
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self objFromJsonData:data];
}

+(id)objFromJsonData:(NSData *)jsonData{

    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if(error){
        kfDebugLog(@"%@",error);
        return nil;
    }else{
        return obj;
    }
}

+(NSString *) objToJsonString:(id) obj{
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
        NSString *value = [self objToJsonString:valueObj];
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
        NSString *value = [self objToJsonString:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

@end
