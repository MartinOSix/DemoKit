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

const void *associateKey = @"associateKeyName";

typedef enum : NSUInteger {
    MyEnumValueA,
    MyEnumValueB,
    MyEnumValueC,
} MyEnum;

@interface testObject ()

@property(nonatomic,strong) NSString *extensionName;

@end

@implementation testObject{
    NSString *privateName;
}

-(void)testPoint{
    NSLog(@"%d",self.age);
    NSLog(@"test point 12");
}

-(void)main{
    
    NSString *strName = @"strName";
    
    objc_setAssociatedObject(self, associateKey, strName, OBJC_ASSOCIATION_COPY);
    
    MyObject *myobj = [[MyObject alloc]init];
    myobj.age = 10;
    //获取实例方法 testPoint
    Method testpoint = class_getInstanceMethod([self class], @selector(testPoint));
    //获取实例方法 getPoint
    Method myobjpoint = class_getInstanceMethod([myobj class], @selector(getPoint));
    
    //获取类方法 class_getClassMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>);
    //交换两个方法的实现
    method_exchangeImplementations(testpoint, myobjpoint);
    NSLog(@"%p",&myobj);
    [myobj getPoint];
    [self testPoint];
    
}

@end
