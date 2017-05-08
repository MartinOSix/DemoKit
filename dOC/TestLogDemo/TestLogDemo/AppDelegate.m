//
//  AppDelegate.m
//  TestLogDemo
//
//  Created by runo on 17/5/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "CCLogSystem.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,NSURLSessionDownloadDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [CCLogSystem setupDefaultLogConfigure];
    NSString *str = @"哈哈哈哈哈哈哈哈哈哈哈😆";
    CC_LOG(@"%@",str);
    CC_LOG_VALUE(str);
    NSLog(@"%@",str);
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
    //设置预设好的交互类型，NSSet里面是设置好的UNNotificationCategory
    [center setNotificationCategories:[self createNotificationCategoryActions]];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus==UNAuthorizationStatusNotDetermined) {
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                } else {
                }
            }];
        }
        else{
            //do other things
        }
    }];
    
    return YES;
}

-(NSSet *)createNotificationCategoryActions{
    //定义按钮的交互button action
    UNNotificationAction * likeButton = [UNNotificationAction actionWithIdentifier:@"see1" title:@"I love it~" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction * dislikeButton = [UNNotificationAction actionWithIdentifier:@"see2" title:@"I don't care~" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //定义文本框的action
    UNTextInputNotificationAction * text = [UNTextInputNotificationAction actionWithIdentifier:@"text" title:@"How about it~?" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //将这些action带入category
    UNNotificationCategory * choseCategory = [UNNotificationCategory categoryWithIdentifier:@"seeCategory" actions:@[likeButton,dislikeButton] intentIdentifiers:@[@"see1",@"see2"] options:UNNotificationCategoryOptionNone];
    UNNotificationCategory * comment = [UNNotificationCategory categoryWithIdentifier:@"seeCategory1" actions:@[text] intentIdentifiers:@[@"text"] options:UNNotificationCategoryOptionNone];
    return [NSSet setWithObjects:choseCategory,comment,nil];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    //应用在前台收到通知
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        completionHandler(UNNotificationPresentationOptionAlert);
        
    }else{//后台通知
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);//option表示以何种方式通知用户
    }
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //点击通知进入应用
    NSLog(@"response:%@", response.actionIdentifier);
    
    //如果在前台设置弹出Alert，上面的option中的aler，则前台点击也会进入这个方法
    completionHandler();
}


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

//AppDelegate.m
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    //Check if all transfers are done, and update UI
    //Then tell system background transfer over, so it can take new snapshot to show in App Switcher
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"bgsession"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    //You can also pop up a local notification to remind the user
    //...
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"本地通知";
    content.subtitle = @"下载完成";
    content.body = identifier;
    content.badge = @10;
    NSError *error = nil;
    //NSString *path = [[NSBundle mainBundle]pathForResource:@"QQ20161017" ofType:@"png"];
    //通知附件内容
    //UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if(error){
        NSLog(@"attachment error %@",error);
    }
    //content.attachments = @[att];
    //content.launchImageName = @"QQ20161017";
    //设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    //设置出发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    //设置UNNotificationRquest
    NSString *requestIdentifer = @"TestRequest";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"requestIdentifer" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"完成");
    }];
    
    completionHandler();
}


@end
