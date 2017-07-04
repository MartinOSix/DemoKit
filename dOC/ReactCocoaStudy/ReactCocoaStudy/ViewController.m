//
//  ViewController.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "ViewController_A.h"
#import "RAC_Test.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation ViewController{
    RACCommand *_command;
    UIButton *_btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self test_Sequence_Tuple];
    
    //[self test_Rac_Command];
    
    //[self test_Rac_btnSingal];
    
    //信号每订阅一次就会被发送一次请求，不想重复就用connection
    //[self test_Rac_MulticastConnection];
    
    //[self test_Rac_Normal];
    
    //[self test_SignalMap];
    
    //[RAC_Test main];
    
    //[self test_filter];
    
    //[self test_take];
    
    //[self test_doCompleted];
    
    //[self test_deliverOn];
    
    //[self test_timeOut];
    
    
    [self test_retry];
}

- (void)test_retry{
    
    //1. retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
    __block int i = 0;
    RACSignal *signal = nil;
    
//    signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        if (i == 10) {
//            [subscriber sendNext:@1];
//        }else{
//            
//            [subscriber sendError:nil];
//        }
//        i++;
//        
//        return nil;
//        
//    }] retry];

    //    2.reply 重放：当一个信号被多次订阅,反复播放内容
    signal = [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@123];
        sleep(4);
        [subscriber sendNext:@345];
        return nil;
    }] replay] subscribeOn:[RACScheduler scheduler]];
    
    
    //throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出
    
    [[signal throttle:2] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"first subscribe %@",x);
    }];

    [signal subscribeNext:^(id x) {
        
        NSLog(@"first subscribe %@",x);
        
    } error:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"second subscribe %@",x);
    }];
}

- (void)test_timeOut{
    
    
    RACSignal *signal = nil;
    //1. 超时3秒
//    signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        return nil;
//    }] timeout:3 onScheduler:[RACScheduler currentScheduler]];
    
//    2. interval 每隔一段时间发送消息
    //signal = [RACSignal interval:3 onScheduler:[RACScheduler currentScheduler]];
    
//    3. delay 延时发送信号
    signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"1234"];
        return nil;
        
    }] delay:3];
    
    [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        
        NSLog(@"error %@",error);
    }];
    
    
    
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@" btn click ");
    }];
}

- (void)test_deliverOn{
    
    //1. deliverOn内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用。
//    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        
//        sleep(3);
//        NSLog(@"%@",[NSThread currentThread]);
//        [subscriber sendNext:@"哈哈哈"];
//        return nil;
//        
//    }] deliverOn:[RACScheduler scheduler]] subscribeNext:^(id  _Nullable x) {
//      
//        NSLog(@"%@",x);
//        NSLog(@"%@",[NSThread currentThread]);
//    }];
    
    //2. subscribeOn 内容传递和副作用都在子线程
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        sleep(3);
        NSLog(@"%@",[NSThread currentThread]);
        [subscriber sendNext:@"哈哈哈"];
        return nil;
        
    }] subscribeOn:[RACScheduler scheduler]] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        NSLog(@"%@",[NSThread currentThread]);
    }];
    
    
}

- (void)test_doCompleted{
    
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)test_take{
    
    
    //创建信号
    RACSubject *signal = [RACSubject subject];
    
    //1. take 处理信号，订阅信号 从开始一共取N次的信号
    [[signal take:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    //2. takeLast
    [[signal takeLast:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    [signal sendNext:@3];
    [signal sendCompleted];
    //去最后N次的信号
    
    //3. takeUntil 监听文本框的改变直到当前对象被销毁
    //RAC(self.showLabel,text) = [_textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
    
    //4. skip 跳过几个信号不接受
    RAC(self.showLabel,text) = [_textField.rac_textSignal skip:10];
    
    //5. switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。

}

- (void)test_filter{
    
    //1.test filter//按条件过滤
//    RACSignal *testSignal = [_textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
//        return value.length > 10;
//    }];
    
//     2. 或略特定值
//    RACSignal *testSignal = [_textField.rac_textSignal ignore:@"abc"];
    
//    3.当两次值明显不一样时才刷新
    RACSignal *testSignal = [_textField.rac_textSignal distinctUntilChanged];
    
    RAC(self.showLabel,text) = _textField.rac_textSignal;
}

- (void)test_SignalMap{
    
    // 创建信号中的信号
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    [[signalOfsignals flattenMap:^RACSignal *(id value) {
        
        // 当signalOfsignals的signals发出信号才会调用
        return value;
        
    }] subscribeNext:^(id x) {
        
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        
        NSLog(@"%@aaa",x);
    }];
    
    // 信号的信号发送信号
    [signalOfsignals sendNext:signal];
    
    // 信号发送内容
    [signal sendNext:@1];
    
}


- (void)btnclick{
    //NSLog(@"按钮点击 btnclick");
}

- (void)test_Rac_Normal{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];

    //1. 替代btn点击事件，但是不是用selectior是用event
    [[self rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"按钮点击");
    }];
    //1.1 监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    //2.替代KVO
    [[btn rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"%@",x);
    }];
    _btn = btn;
    
    //3. 代理通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        NSLog(@"键盘弹出");
    }];
    
    //4.1 监听文本变化,文本变化之后
    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"文字改变了 %@ %@",x,[NSThread currentThread]);
        if (x.length > 10) {
            _btn.hidden = YES;
        }else{
            _btn.hidden = NO;
        }
    }];
    
    //4.2 监听文本变化，文本变化之前
//    [[_textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
//        
//        return ^RACSignal *(id value, BOOL *stop){
//            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
//        };
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    //4.2 监听文本变化，改变之前的文本
    [[_textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        return [RACReturnSignal return:[NSString stringWithFormat:@"%@++",value]];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //5. 处理多个请求
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@"发送请求1"];
        return  nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:nil];
        return  nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIWithR1:R2:) withSignalsFromArray:@[request1,request2]];
    
    //6. 常见宏
    //6.1 当text 文字改变时，label.text = textfield.text
    RAC(self.showLabel,text) = self.textField.rac_textSignal;
    
    //6.2 订阅监听属性
    [RACObserve(_btn, center) subscribeNext:^(id  _Nullable x) {
        NSLog(@"-RACObserve- %@",x);
    }];
    
    //6.3 元祖包装
    RACTuple *tuple = RACTuplePack(@"avc",@33,@"vg");
    
    RACTupleUnpack(NSString *name1,NSString *name2,NSNumber *age) = tuple;
    NSLog(@"RACTupleUnpack  %@   %@   %@",name1,name2,age);
    
}

- (void)updateUIWithR1:(id)data R2:(id)data2{
    NSLog(@"updateUI %@   %@",data,data2);
}


- (void)test_Rac_MulticastConnection{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        return  nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据 - 1");
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据 - 2");
    }];
    
    
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅一 信号");
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅二 信号");
    }];
    
    [connection connect];
    
    
}

- (void)test_Rac_btnSingal{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    btn.tag = 1001;
    RACSignal *btnSignal = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [btnSignal subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"btn tag %zd click",x.tag);
    }];
    
    [btnSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"btn 2 tag click %zd",((UIControl *)x).tag);
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
    
    //1、替代代理
    /*
    ViewController_A *view = [[ViewController_A alloc]initWithNibName:@"ViewController_A" bundle:nil];
    view.delegateSingnal = [RACSubject subject];
    [view.delegateSingnal subscribeNext:^(id  _Nullable x) {
        NSLog(@"View 收到通知");
    }];
    [self presentViewController:view animated:YES completion:nil];
     */
    
    //2、配合Rac_Normal
    _btn.center = CGPointMake(100, 100);
}


@end
