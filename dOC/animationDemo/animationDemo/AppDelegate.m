//
//  AppDelegate.m
//  animationDemo
//
//  Created by runo on 16/9/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#define vcname "ViewController9.h"
#define vcName @"ViewController9"

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController2.h"
#import "ViewController5.h"
#import "ViewController10.h"
#import "MainViewController.h"
#import vcname

@interface AppDelegate ()<UITabBarControllerDelegate>

@property(nonatomic,copy) NSString *hehe;//!<哈哈哈哈

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    UIViewController *viewA = [[UIViewController alloc]init];
    UIViewController *viewB = [[UIViewController alloc]init];
    viewA.view.backgroundColor = [UIColor redColor];
    viewB.view.backgroundColor = [UIColor blueColor];
    tabBar.viewControllers = @[viewA,viewB];
    tabBar.view.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[MainViewController new]];
    
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    CATransition *tran = [CATransition animation];
    tran.type = kCATransitionMoveIn;
    [tabBarController.view.layer addAnimation:tran forKey:nil];
    
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
