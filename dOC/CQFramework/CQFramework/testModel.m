//
//  testModel.m
//  CQFramework
//
//  Created by runo on 17/2/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "testModel.h"

@implementation testModel


-(NSString *)haha{

    return @"haha";
}

+(float)cqTableVersion{
    return 1.2;
}

+(BOOL)cqIsPrimaryKey:(NSString *)property{
    return NO;
}


@end
