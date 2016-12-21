//
//  AppDelegate.h
//  CQFramework
//
//  Created by runo on 16/10/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)changeRootController:(UIViewController *)vc Animate:(BOOL)animal;

-(void)changeRootController:(UIViewController *)vc FromVC:(UIViewController *)fromvc Animate:(BOOL)animal;

@end

