//
//  main.m
//  RuntimeDemo
//
//  Created by runo on 17/1/6.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyObject.h"
#import "testObject.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        testObject *test = [[testObject alloc]init];
        //测试两个不同对象的方法交换
        [test main];
        
        MyObject *my = [MyObject new];
        [my getPoint];
        
        NSLog(@"%@",[[test superclass] fetchIvarList]);
        
        //获取类的成员变量
        NSLog(@"%@",[testObject fetchIvarList]);
        
        //获取成员属性
        NSLog(@"%@",[testObject fetchPropertyList]);
        
        //获取对象方法列表
        NSLog(@"%@",[NSArray fetchInstanceMethodList]);
        
        //获取类方法列表
        NSLog(@"%@",[NSArray fetchClassMethodList]);
        
        //获取协议列表
        NSLog(@"%@",[NSArray fetchProtocolList]);
    }
    return 0;
}






















