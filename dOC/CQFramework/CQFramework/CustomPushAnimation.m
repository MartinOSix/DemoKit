//
//  CustomPushAnimation.m
//  CQFramework
//
//  Created by runo on 16/12/1.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CustomPushAnimation.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

//自定义Navigationcontroller 的push pop 动画

@interface CustomPushAnimation ()



@end

@implementation CustomPushAnimation{
    BOOL _Push;
}


-(instancetype)initWithIsPush:(BOOL)isPush{
    self = [super init];
    if (self) {
        
        _Push = isPush;
        
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.5;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.clipsToBounds = YES;
    fromVC.view.clipsToBounds = YES;
    UIView *container = [transitionContext containerView];
    
    if (_Push) {
        toVC.view.frame = CGRectMake(kScreenWidth/2, kScreenHeight/2, 0, 0);
        [container addSubview:toVC.view];
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        
        [container addSubview:toVC.view];
        [container addSubview:fromVC.view];
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            fromVC.view.frame = CGRectMake(kScreenWidth/2, kScreenHeight/2, 0, 0);
            
            
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
    
    
}

@end
