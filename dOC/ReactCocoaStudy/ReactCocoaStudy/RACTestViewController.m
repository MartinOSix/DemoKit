//
//  RACTestViewController.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "RACTestViewController.h"

@interface RACTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testField;

@end

@implementation RACTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self testFlatMap];
    
    //[self testConcat];
    
    //[self testThen];
    
    //[self testMerge];
    
    //[self testZip];
    
    //[self combineLatest];
}

- (void)testReduce{
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@2];
        return nil;
    }];
    
    
}

- (void)combineLatest{
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@1];
        return nil;
    }];
    
    RACSubject *sub1 = [RACSubject subject];
    
    RACSignal *combine = [signalA combineLatestWith:sub1];
    [combine subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [sub1 sendNext:@22];
    [sub1 sendNext:@33];
    
    
}


- (void)testZip{
    
    RACSubject *sub1 = [RACSubject subject];
    RACSubject *sub2 = [RACSubject subject];
    
    RACSignal *zipSignal = [sub1 zipWith:sub2];
    [zipSignal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"%@",x);
        RACTupleUnpack(NSString *name1, NSString *name2) = x;
        NSLog(@"%@  %@",name1,name2);
    }];
    
    [sub1 sendNext:@"123"];
    [sub2 sendNext:@"234"];
    
}

- (void)testMerge{
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@1];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@2];
        return nil;
    }];
    
    RACSubject *sub1 = [RACSubject subject];
    
    RACSignal *mergeSignal = [[signalA merge:signalB] merge:sub1];
    
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [sub1 sendNext:@123];
    
}

- (void)testThen{
    
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
        NSLog(@"%@",x);
    }];
    
}

- (void)testConcat{
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
        
    }];
    
    
    RACSubject *sub = [RACSubject subject];
    RACSignal *concatSignal = [[sub concat:signalB] concat:signalA];
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [sub sendNext:@"2"];
    [sub sendCompleted];
    
}

- (void)testFlatMap{
    
    [[self.testField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        
        return [RACReturnSignal return:[NSString stringWithFormat:@"add%@",value]];
        
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [[self.testField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [NSString stringWithFormat:@"%@+append",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //map 与 flatmap的区别：一个返回的是信号，一个返回的是对象，主要看实际使用情况
}

//textView信号绑定
- (void)testTestSignal{
    //正常的信号订阅
    [self.testField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
        NSLog(@"input text %@",x);
        
    }];
    
    
    //bind方法的使用
    [[self.testField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal*(NSNumber * value,BOOL *stop){
            if ([value integerValue] == 123) {
                *stop = YES;
            }
            if ([value integerValue] == 321) {
                *stop = NO;
            }
            //以信号的形式返回处理过的数据
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出值 %@",value]];
        };
        
        //订阅绑定之后的信号
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"2- %@",x);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
