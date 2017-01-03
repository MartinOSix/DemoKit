//
//  ViewController_Operation.m
//  SDWebTest
//
//  Created by runo on 16/12/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController_Operation.h"
#import <CoreFoundation/CFRunLoop.h>

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface SubOperation : NSOperation

@end

@implementation SubOperation

-(void)main{
    int i = 0;
    while (i < 20) {
        sleep(1);
        i++;
        NSLog(@"%d",i);
        NSLog(@"%@",[NSThread currentThread]);
    }
    
}

@end

@interface ViewController_Operation ()

@property(nonatomic,strong)NSOperationQueue *opqueue;
@property(nonatomic,strong)NSDictionary *cacheOperation;

@end

@implementation ViewController_Operation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    static NSString * const str = @"name";
    
    
}

-(void)testRunloop2{
    __weak __typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"ThreadIsMain %d--",[NSThread isMainThread]);
        NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:weakSelf selector:@selector(timeTask) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        BOOL condition = YES;
        while (condition) {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
            NSLog(@"检查一下");
        }
        
    }];
    self.opqueue = [[NSOperationQueue alloc]init];
    [self.opqueue addOperation:blockOperation];
    
}

-(void)timeTask{
    
    static int i = 0;
    NSLog(@"%d",i);
    NSLog(@"%p --",[NSRunLoop currentRunLoop]);
    i++;

}

-(void)testRunloop1{
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LaunchImage-800-667h"]];
    imageV.frame = kScreenBounds;
    [self.view addSubview:imageV];
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300) style:UITableViewStylePlain];
    [self.view addSubview:tab];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%p",[NSRunLoop currentRunLoop]);
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        NSLog(@"ismain %d--",[NSThread isMainThread]);
        static int i = 0;
        NSLog(@"---%d",i);
        i++;
        if (i == 10) {
            [timer invalidate];
        }
    }];
    
    NSRunLoop *mainloop = [NSRunLoop mainRunLoop];
    NSRunLoop *currentloop = [NSRunLoop currentRunLoop];
    CFRunLoopRef ref = currentloop.getCFRunLoop;
    CFRunLoopObserverRef obref = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        
        /*
         kCFRunLoopEntry = (1UL << 0),          进入工作
         kCFRunLoopBeforeTimers = (1UL << 1),   即将处理Timers事件
         kCFRunLoopBeforeSources = (1UL << 2),  即将处理Source事件
         kCFRunLoopBeforeWaiting = (1UL << 5),  即将休眠
         kCFRunLoopAfterWaiting = (1UL << 6),   被唤醒
         kCFRunLoopExit = (1UL << 7),           退出RunLoop
         kCFRunLoopAllActivities = 0x0FFFFFFFU  监听所有事件
         */
        
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理Timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理Source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将休眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"退出RunLoop");
                break;
            default:
                break;
        }
    });
    //CFRunLoopAddObserver(ref, obref, kCFRunLoopCommonModes);
    
    NSRunLoop *currentloop2 = [NSRunLoop currentRunLoop];
    NSRunLoop *currentloop3 = [NSRunLoop currentRunLoop];
    //[currentloop addTimer:timer forMode:NSRunLoopCommonModes];
    NSLog(@"main %p  cur %p  cur2 %p  cur3 %p",&mainloop,&currentloop,&currentloop2,&currentloop3);
}

-(NSNumber *)countInt{
    int i = 0;
    while (i < 10) {
        i++;
        sleep(1);
        NSLog(@"%d--",i);
    }
    return @(i);
}

-(void)testBlockOperation{
    SubOperation *operation = [[SubOperation alloc]init];
    NSLog(@"%@",[NSThread mainThread]);
    [operation setCompletionBlock:^{
        NSLog(@"执行结束");
    }];
    self.opqueue = [[NSOperationQueue alloc]init];
    //[self.opqueue addOperation:operation];
    NSLog(@"%@",operation.finished?@"YES":@"NO");
    NSBlockOperation *blockop = [[NSBlockOperation alloc]init];
    
    [blockop setCompletionBlock:^{
        NSLog(@"完成--");
        
    }];
    
    [blockop addExecutionBlock:^{
        int i = 0;
        while (i < 5) {
            NSLog(@"A %d  %@",i,[NSThread currentThread]);
            sleep(1);
            i++;
        }
    }];
    //[self.opqueue addOperation:blockop];
    [blockop addExecutionBlock:^{
        int i = 0;
        while (i < 5) {
            NSLog(@"B %d  %@",i,[NSThread currentThread]);
            sleep(1);
            i++;
        }
    }];
    NSLog(@"cancel %d  excuting %d  asnyn  %d   ready %d  isfinish %d",blockop.isCancelled,blockop.isExecuting,blockop.isAsynchronous ,blockop.isReady,blockop.isFinished);
    [blockop start];
    sleep(2);
    
    
    NSLog(@"cancel %d  excuting %d  asnyn  %d   ready %d  isfinish %d",blockop.isCancelled,blockop.isExecuting,blockop.isAsynchronous ,blockop.isReady,blockop.isFinished);
    NSLog(@"%d",blockop.isFinished);
    //
    //    NSLog(@"%d--",blockop.isExecuting);
    //    [blockop addExecutionBlock:^{
    //        int i = 0;
    //        while (i < 5) {
    //            NSLog(@"C %d",i);
    //            sleep(1);
    //            i++;
    //        }
    //    }];
    
    
    //[self testOperationQueue];
}

-(void)testOperationQueue{
    
    self.opqueue = [[NSOperationQueue alloc]init];
    self.opqueue.maxConcurrentOperationCount = 3;
    
    NSLog(@"%@",[NSThread mainThread]);
    
    for (int i = 0; i < 13; i++) {
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            int j = 0;
            while (j < 13) {
                sleep(1);
                NSLog(@"%c--%d  %@",'A'+i,j,[NSThread currentThread]);
                //NSLog(@"%@  %d",self.opqueue.operations,self.opqueue.operationCount);
                j++;
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"%c--结束  %@",'A'+i,[NSThread currentThread]);
            }];
        }];
        //NSLog(@"%@",blockOperation);
        [self.opqueue addOperation:blockOperation];
        //        [self.opqueue addOperations:@[blockOperation] waitUntilFinished:NO];
        //NSLog(@"%@  %d",self.opqueue.operations,self.opqueue.operationCount);
    }
    NSLog(@"开始挂起");
    //[self.opqueue setSuspended:YES];
    //sleep(30);
    //[self.opqueue setSuspended:NO];
    //[self.opqueue waitUntilAllOperationsAreFinished];
    
    NSLog(@"运行完成");
    NSLog(@"%@",self.opqueue.operations);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
