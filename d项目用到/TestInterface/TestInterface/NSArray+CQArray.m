//
//  NSArray+CQArray.m
//  CarServiceLeague
//
//  Created by runo on 16/8/11.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "NSArray+CQArray.h"

@implementation NSArray (CQArray)

-(id)cqObjectAtIndex:(NSUInteger)index{
    
    if(index >= self.count){
        return nil;
    }else{
        return [self objectAtIndex:index];
    }
    
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    
    // 开头有个[
    [string appendString:@"[\n"];
    
    // 遍历所有的元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    
    // 结尾有个]
    [string appendString:@"]"];
    
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
}

@end
