//
//  UIView+HUD.h
//  MBProgressDemo
//
//  Created by runo on 17/3/8.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)

-(void)hudShowActivityMessageInWindow:(NSString *)message;
-(void)hudHidenActivity;

@end
