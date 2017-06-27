//
//  ViewController.m
//  MultiThread
//
//  Created by runo on 17/6/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self testNSThread];
    
    [self testBlock];
    
}

- (void)testBlock{
    
    //，并发队列
    dispatch_queue_t ConcurrentQueue = dispatch_queue_create("hehe", DISPATCH_QUEUE_CONCURRENT);
    //，串行队列
    dispatch_queue_t SerialQueue = dispatch_queue_create("hehe", DISPATCH_QUEUE_SERIAL);
    //异步执行
    dispatch_async(SerialQueue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"%@ _%d",[NSThread currentThread],i);
        }
    });
    //同步执行
    dispatch_sync(SerialQueue, ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"同步执行，并发队列%@ _%d",[NSThread currentThread],i);
        }
    });
    
    for (int i = 0; i < 100; i++) {
        NSLog(@"%@ _%d",[NSThread currentThread],i);
    }
    NSLog(@"哈哈哈哈");
}


- (void)testNSThread{
    
    
    NSThread *thread = [[NSThread alloc]initWithBlock:^{
        NSLog(@"sub Thtead");
    }];
    [thread start];
    //死锁了，主线程在等这个线程结束，但是这个线程又在等启动，放在前面还没设置，放在后面又不会执行到
    [self performSelector:@selector(subTestNSThread) onThread:thread withObject:nil waitUntilDone:YES];
    for (int i = 0; i < 100; i++) {
        NSLog(@"%@ _%d",[NSThread currentThread],i);
    }
    
    NSThread *thread_1 = [[NSThread alloc]initWithBlock:^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"%@ _%d",[NSThread currentThread],i);
        }
    }];
    thread_1.name = @"block";
    [thread_1 start];
    
    NSThread *thread_2 = [[NSThread alloc]initWithTarget:self selector:@selector(subTestNSThread) object:nil];
    thread_2.name = @"method";
    [thread_2 start];
}

- (void)subTestNSThread{
    for (int i = 0; i < 100; i++) {
        NSLog(@"%@ _%d",[NSThread currentThread],i);
    }
}


@end
