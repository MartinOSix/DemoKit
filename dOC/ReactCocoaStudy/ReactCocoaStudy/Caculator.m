//
//  Caculator.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "Caculator.h"

@implementation Caculator

-(instancetype)init{
    if (self = [super init]) {
        _isEqule = NO;
        _result = 0;
    }
    return self;
}

//函数式编程思想：每个方法必须有返回值（对象本身），把函数或者block当做参数，block的参数是需要（操作的值），block的返回值时（操作结果）
-(Caculator *)caculator:(int (^)(int))caculator{
    
    self.result = caculator(self.result);
    return self;
}

-(Caculator *)equal:(BOOL (^)(int))operation{
    
    self.isEqule = operation(self.result);
    return self;
}


@end
