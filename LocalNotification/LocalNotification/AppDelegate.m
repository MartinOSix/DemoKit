//
//  AppDelegate.m
//  LocalNotification
//
//  Created by runo on 16/10/17.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "AppDelegate.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
//本地推送， 本地化操作
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    //取消本地通知
    //[[UNUserNotificationCenter currentNotificationCenter]removePendingNotificationRequestsWithIdentifiers:@[@"requestIdentifer"]];
    
    //10.0注册推送
    if([[UIDevice currentDevice].systemVersion floatValue]>= 10.0){
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
           
            if (granted) {
                //点击允许接收通知
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@",settings);
                }];
                
            }else{
                NSLog(@"注册失败");
            }
            
        }];

        //iOS 8 - 10
    }else if([[UIDevice currentDevice].systemVersion floatValue] > 8.0){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

#pragma mark - 推送
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSLog(@"前台接收通知进入");
    NSDictionary *userInfo = notification.request.content.userInfo;
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送消息的内容
    UNNotificationContent *content = request.content;
    //推送消息的角标
    NSNumber *badge = content.badge;
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    //消息体
    NSString *body = content.body;
    //声音
    UNNotificationSound *sound = content.sound;
    //副标题
    NSString *subtitle = content.subtitle;
    //主标题
    NSString *title = content.title;
    //远程通知
    if ([notification.request.trigger isKindOfClass:
         
         [UNPushNotificationTrigger class]]) {
        NSLog(@"ios10收到远程通知:%@",userInfo);
        
        //本地通知
    }else{
        
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        
    }
    completionHandler(UNAuthorizationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSLog(@"后台点击通知进入");
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送消息的内容
    UNNotificationContent *content = request.content;
    //推送消息的角标
    NSNumber *badge = content.badge;
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    //消息体
    NSString *body = content.body;
    //声音
    UNNotificationSound *sound = content.sound;
    //副标题
    NSString *subtitle = content.subtitle;
    //主标题
    NSString *title = content.title;
    //远程通知
    if ([response.notification.request.trigger isKindOfClass:
        
         [UNPushNotificationTrigger class]]) {
        NSLog(@"ios10收到远程通知:%@",userInfo);
    
    //本地通知
    }else{
        
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);

    }
    completionHandler();//!<系统强制执行该方法
    
}

#pragma mark - Application生命周期
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
