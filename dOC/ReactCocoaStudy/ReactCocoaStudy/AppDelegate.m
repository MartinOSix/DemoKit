//
//  AppDelegate.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "AppDelegate.h"
#import "Caculator.h"
#import "ViewController.h"
#import "MVVMLoginViewController.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MVVMLoginViewController *vc = [[MVVMLoginViewController alloc]initWithNibName:@"MVVMLoginViewController" bundle:nil];
    self.window = [[UIWindow alloc]initWithFrame:kScreenBounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    UIImage *image = [UIImage imageNamed:@"QQ20170706-0"];
    NSLog(@"--- 1   %p  %p",image.CGImage,image.CIImage);
    
    return YES;
}

//测试函数编程方式
- (void)test_Caculator{
    
    Caculator *c = [[Caculator alloc]init];
    BOOL isEqual = [[[c caculator:^int(int result) {
        result += 2;
        result += 5;
        return result;
    }] equal:^BOOL(int result) {
        return result == 10;
    }] isEqule];
    NSLog(@"%d",isEqual);
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


@end
