//
//  testObject.m
//  RuntimeDemo
//
//  Created by runo on 17/1/6.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "testObject.h"
#import "MyObject.h"
#import <objc/runtime.h>
/*!
    注释
    - MyEnumValueA: 默认
 */
typedef enum : NSUInteger {
    MyEnumValueA,
    MyEnumValueB,
    MyEnumValueC,
} MyEnum;

@implementation testObject

-(void)testPoint{
    NSLog(@"%d",self.age);
    NSLog(@"test point 12");
}

-(void)main{
    
    MyObject *myobj = [[MyObject alloc]init];
    myobj.age = 10;
    Method testpoint = class_getInstanceMethod([self class], @selector(testPoint));
    Method myobjpoint = class_getInstanceMethod([myobj class], @selector(getPoint));
    method_exchangeImplementations(testpoint, myobjpoint);
    NSLog(@"%p",&myobj);
    [myobj getPoint];
    [self testPoint];
    
}

@end
