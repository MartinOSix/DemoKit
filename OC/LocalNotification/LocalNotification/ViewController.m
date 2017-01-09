//
//  ViewController.m
//  LocalNotification
//
//  Created by runo on 16/10/17.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "BaseBViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 100, 30)];
    label.text = NSLocalizedStringFromTable(@"LabelName", @"MultiLanguage", nil);
    [self.view addSubview:label];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 100, 30)];
    field.delegate = self;
    field.backgroundColor = [UIColor blueColor];
    [self.view addSubview:field];
    
    
    //ios8.0一下
    [[UIApplication sharedApplication]enabledRemoteNotificationTypes];
    //ios8.0 以上含
    [[UIApplication sharedApplication]isRegisteredForRemoteNotifications];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        if ([[UIApplication sharedApplication]isRegisteredForRemoteNotifications]) {
            NSLog(@"开了");
        }else{
            NSLog(@"没开");
        }
        
    }else{
        if ([[UIApplication sharedApplication]enabledRemoteNotificationTypes]) {
            NSLog(@"开了");
        }else{
            NSLog(@"没开");
        }
    }
    NSLog(@"%@",NSHomeDirectory());
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(get:) name:@"123" object:nil];
}

-(void)get:(NSNotification *)not{
    if ([NSThread isMainThread]) {
        NSLog(@"是主线程");
    }else{
        NSLog(@"不是主线程");
    }
    NSLog(@"%p",[NSThread currentThread]);
    NSLog(@"%@",not.userInfo);
    sleep(5);
}

-(void)send{
    [self.navigationController pushViewController:[BaseBViewController new] animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendLocaNotification{
    //创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"本地通知测试";
    content.subtitle = @"本地副标题";
    content.body = @"通知内容体";
    content.badge = @2;
    content.userInfo = @{@"abc":@"123",@"haha":@"hehe"};
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"QQ20161017" ofType:@"png"];
    //通知附件内容
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if(error){
        NSLog(@"attachment error %@",error);
    }
    content.attachments = @[att];
    content.launchImageName = @"QQ20161017";
    //设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    //设置出发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:70 repeats:YES];
    //设置UNNotificationRquest
    NSString *requestIdentifer = @"TestRequest";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"requestIdentifer" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"完成");
    }];
    
}

@end





















