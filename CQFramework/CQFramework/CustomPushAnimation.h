//
//  CustomPushAnimation.h
//  CQFramework
//
//  Created by runo on 16/12/1.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CustomPushAnimation : NSObject<UIViewControllerAnimatedTransitioning>

-(instancetype)initWithIsPush:(BOOL)isPush;

@end
