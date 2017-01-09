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


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        testObject *test = [[testObject alloc]init];
        
        [test main];
        
        
        
    }
    return 0;
}






















