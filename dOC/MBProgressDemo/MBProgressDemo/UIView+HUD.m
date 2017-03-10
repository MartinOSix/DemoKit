//
//  UIView+HUD.m
//  MBProgressDemo
//
//  Created by runo on 17/3/8.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const NSString * ACTIVITY_HUD = @"ACTIVITY_HUD";

@implementation UIView (HUD)

-(void)hudShowActivityMessageInWindow:(NSString *)message{
    
    MBProgressHUD *activityHud = (MBProgressHUD *)objc_getAssociatedObject(self, &ACTIVITY_HUD);
    self.userInteractionEnabled = NO;
    if (activityHud != nil){
        activityHud.labelText = message;
        return;
    }
    activityHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    activityHud.labelText = message?message:@"加载中......";
    activityHud.labelFont=[UIFont systemFontOfSize:15];
    activityHud.removeFromSuperViewOnHide = YES;
    activityHud.dimBackground = NO;
    activityHud.mode = MBProgressHUDModeIndeterminate;
    activityHud.autoresizingMask = UIViewAutoresizingNone;
    objc_setAssociatedObject(self, &ACTIVITY_HUD, activityHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)hudHidenActivity{
    
    MBProgressHUD *activityHud = (MBProgressHUD *)objc_getAssociatedObject(self, &ACTIVITY_HUD);
    self.userInteractionEnabled = YES;
    if (activityHud != nil) {
        [activityHud hide:YES];
        objc_setAssociatedObject(self, &ACTIVITY_HUD, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
}


@end












