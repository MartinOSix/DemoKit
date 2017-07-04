//
//  LoginViewModel.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

-(AccountModel *)account{
    if (_account == nil) {
        _account = [[AccountModel alloc]init];
    }
    return _account;
}

-(instancetype)init{
    if (self = [super init]) {
        _loginSuccess = NO;
        [self initialBing];
    }
    return  self;
}

- (void)initialBing{
    
    //监听站好属性改变，把他们聚合成一个信号
    _loginBtnEnabelSignal = [[RACSignal combineLatest:@[RACObserve(self.account, name),RACObserve(self.account, password)]] reduceEach:^id(NSString *name,NSString *password){
        return @(name.length && password.length);
    }];
    
    //处理登录业务逻辑
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           //延时调用
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"登录成功"];
                [subscriber sendCompleted];
           });
            return nil;
        }];
    }];
    
    
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if ([x isEqualToString:@"登录成功"]) {
            self.loginSuccess = YES;
        }
    }];
    
    [[_loginCommand.executing skip:1] subscribeNext:^(id  _Nullable x) {
       
        if ([x isEqualToNumber:@(1)]) {
            NSLog(@"登录中...");
        }else{
            NSLog(@"登录结束");
        }
        
    }];
}

@end
