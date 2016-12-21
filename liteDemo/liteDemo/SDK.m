//
//  SDK.m
//  liteDemo
//
//  Created by runo on 16/12/8.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "SDK.h"


@interface SDK ()

//@property(nonatomic,strong)dispatch_group_t group;

@end

@implementation SDK{
    dispatch_group_t group;
}

+(instancetype)sharInstance{
    
    static SDK *sdk = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
       
        sdk = [[SDK alloc]init];
        [sdk baseSeting];
    });
    return sdk;
}

-(void)baseSeting{
    group = dispatch_group_create();
    
}

-(void)MethodA{
    NSLog(@"A方法开始执行");
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(5);
        NSLog(@"方法A异步回调结果");
        dispatch_group_leave(group);
    });
    NSLog(@"A方法结束");
}

-(void)MethodB{
    NSLog(@"B方法开始执行");
    
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            sleep(5);
            NSLog(@"方法B异步回调结果");
            if (self.result) {
                self.result(@"最终结果");
            }
        
    });
        
    NSLog(@"B方法结束");
}



@end
