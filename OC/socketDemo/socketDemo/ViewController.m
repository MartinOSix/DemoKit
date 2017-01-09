//
//  ViewController.m
//  socketDemo
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"


#define ipAddress @"192.168.1.121"
#define ipPort 8989

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController ()<GCDAsyncSocketDelegate>

@property(nonatomic,strong) GCDAsyncSocket *socket;

@end

@implementation ViewController{
    UITextField *_field;
    UIButton *_reconnectBtn;//!<重连button
    UIButton *_sendBtn;//!<发送btn
    UILabel *_label;
    UIButton *_disConnect;//!<断开连接
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [self.socket connectToHost:ipAddress onPort:ipPort error:&error];
    
    _field = ({
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 30)];
        field.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:field];
        field;
    });
    
    _reconnectBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 50, 80, 30);
        [btn setTitle:@"reconnect" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    self.view.backgroundColor = [UIColor blackColor];
    _sendBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 50, 80, 30);
        [btn setTitle:@"send" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sendMsgBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    
    _label = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight-100)];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        label;
    });
    
    _disConnect = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(190, 50, 80, 30);
        [btn setTitle:@"diconnect" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(disConnectClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
}

-(void)disConnectClick{
    
    if([self.socket isConnected]){
        [self.socket disconnect];
    }
    
}

-(void)sendMsgBtnClick{
    
    static int i = 0;
    //发送消息
    NSString *str = _field.text;
    NSDictionary *dic = @{@"form":@"iphone",@"msg":str,@"to":@"mac"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [self.socket writeData:data withTimeout:-1 tag:i];
    i++;
}

-(void)connectBtnClick{
    [self.socket connectToHost:ipAddress onPort:ipPort error:nil];
}


#pragma mark - socketDelegate
/**连接成功回调*/
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    NSLog(@"连接socket成功 端口%d",port);
    
    
}

/**连接失败回调*/
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    NSLog(@"连接socket失败 %@",err);
    //重连就再次调用连接请求
    
}

/**发送成功回调*/
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    NSLog(@"tag %ld 发送成功",tag);
    [sock readDataWithTimeout:-1 tag:0];
}

/**读取消息回调*/
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    [sock readDataWithTimeout:-1 tag:0];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *mstr = [NSMutableString stringWithFormat:@"%@\n%@",_label.text,str];
    _label.text = mstr;
    NSLog(@"收到回复的消息 %@  tag  %ld",str,tag);
    
}

@end
