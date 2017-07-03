//
//  ViewController.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "ViewController_A.h"

@interface ViewController ()

@end

@implementation ViewController{
    RACCommand *_command;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self test_Sequence_Tuple];
    
    //[self test_Rac_Command];
    
    [self test_Rac_btnSingal];
    
}

- (void)test_Rac_MulticastConnection{
    
    
    
}

- (void)test_Rac_btnSingal{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    btn.tag = 1001;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"btn tag %zd click",x.tag);
    }];
    
}

- (void)test_Rac_Command{
    
    //1、创建命令
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        //空命令
        //return [RACSignal empty];
        
        //2、创建信号传递数据
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"请求数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    _command = command;//强引用防止提前释放接收不到数据
    
    //3、订阅RACCommand中的信号
    [_command.executionSignals subscribeNext:^(id  _Nullable x) {
       [x subscribeNext:^(id  _Nullable x) {
           NSLog(@"-- %@",x);
       }];
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"-高级用法获取- %@",x);
    }];
    
    //4、监听命令是否执行完毕，默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完毕");
        }
    }];
    
    //5、执行命令
    [_command execute:@1];
}

- (void)test_Sequence_Tuple{
    
    //1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@  %@",key,value);
    }];
    
    //3.高级用法
    NSArray *dicArr = @[@{@"name":@"haha",@"age":@12},@{@"name":@"lee",@"age":@30},@{@"name":@"liu",@"age":@40}];
    NSArray *nameArr = [[dicArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return value[@"name"];
    }] array];
    NSLog(@"%@ ",nameArr);
    
}

//应用回调
- (IBAction)btnClick:(id)sender {
    
    ViewController_A *view = [[ViewController_A alloc]initWithNibName:@"ViewController_A" bundle:nil];
    view.delegateSingnal = [RACSubject subject];
    [view.delegateSingnal subscribeNext:^(id  _Nullable x) {
        NSLog(@"View 收到通知");
    }];
    [self presentViewController:view animated:YES completion:nil];
}


@end
