//
//  ViewController.m
//  TestLogDemo
//
//  Created by runo on 17/5/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "CCLogSystem.h"
@interface ViewController ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property(nonatomic,strong) NSURLSession *session;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,strong) NSMutableData *mdata;
@end

@implementation ViewController

-(void)addLog{
    NSDate *date = [NSDate date];
    NSLog(@"%@",date);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Open Developer UI" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addLog) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    
    NSMutableArray *constraits = [NSMutableArray array];
    [constraits addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [constraits addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraints:constraits];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openDeveloperUI)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    
    NSURLSession *session = [[NSURLSession alloc]init];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"bgsession"];
    session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    self.session = session;
    [self beginTask];
    
    self.mdata = [NSMutableData data];
}

-(void)beginTask{
    
    NSString *url = @"http://sw.bos.baidu.com/sw-search-sp/software/18c493082c657/youkumac_1.2.3.04252.dmg";
    NSURL *downloadURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"finish");
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%f",progress);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openDeveloperUI
{
    [CCLogSystem activeDeveloperUI];
}

-(void)popNot{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"本地通知";
    content.subtitle = @"下载完成";
    content.body = @"test";
    content.badge = @1;
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
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    //设置UNNotificationRquest
    //NSString *requestIdentifer = @"TestRequest";
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"requestIdentifer" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"完成");
    }];

}

@end
