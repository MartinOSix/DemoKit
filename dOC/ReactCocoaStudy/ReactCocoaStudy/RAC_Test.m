//
//  RAC_Test.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "RAC_Test.h"

@implementation RAC_Test

+(void)main{
    
    static RAC_Test *test = nil;
    if (test == nil) {
        test = [[RAC_Test alloc]init];
    }
    
    //[test test_Concat];
    
    //[test test_Then];
    
    //[test test_Merge];
    
//    [test test_ZipWith];
    
//    [test test_CombineLatest];
 
//    [test test_reduce];
    
    [test test_filter];
}

- (void)test_filter{
    
    //建 viewcontroller
}

- (void)test_reduce{
    // 聚合
    // 常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    // reduce中的block简介:
    // reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    // reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@1];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@2];
        return nil;
    }];
    
    RACSignal *reduceSignal = [[RACSignal combineLatest:@[signalA,signalB]] reduceEach:^id(NSNumber *num1,NSNumber *num2) {
        return [NSString stringWithFormat:@"%@ x %@",num1,num2];
    }];
    
    [reduceSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}

- (void)test_CombineLatest{
    
    //将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。与zip比较，zip是要两个同时
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber  sendNext:@1];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            [subscriber sendNext:@5];
            
        });
        return nil;
    }];
    
    RACSignal *combineSignal = [signalA combineLatestWith:signalB];
    [combineSignal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"%@",x);
    }];
    // 底层实现：
    // 1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
    // 2.并且把两个信号组合成元组发出。
}

- (void)test_ZipWith{
    
    //:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            [subscriber sendNext:@2];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(3);
                [subscriber sendNext:@5];
            });
        });
        
        return nil;
    }];
    
    //压缩信号A ,信号B
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 底层实现:
    // 1.定义压缩信号，内部就会自动订阅signalA，signalB
    // 2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出。
    
}

- (void)test_Merge{
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@2];
        return nil;
    }];
    
    //合并信号，任何一个信号有消息都会受到
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    // 底层实现：
    // 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
    // 2.每发出一个信号，这个信号就会被订阅
    // 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
    // 4.只要有一个信号被发出就会被监听。
}

- (void)test_Then{

    // then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    // 注意使用then，之前信号的值会被忽略掉.
    // 底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal * _Nonnull{
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
         NSLog(@"%@",x);
    }];

}


- (void)test_Concat{
    
    //按照一定顺序拼接信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@2];
        return nil;
    }];
    //signalA拼接到signalB后，signalA发送完成，signalB才会被激活
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-- %@",x);
    }];
    // concat底层实现:
    // 1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    // 2.didSubscribe中，会先订阅第一个源信号（signalA）
    // 3.会执行第一个源信号（signalA）的didSubscribe
    // 4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    // 5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    // 6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    // 7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
}


@end
