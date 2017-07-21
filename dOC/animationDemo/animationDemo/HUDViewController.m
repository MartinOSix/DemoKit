//
//  HUDViewController.m
//  animationDemo
//
//  Created by runo on 17/7/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "HUDViewController.h"

@interface HUDView : UIView
@end
@implementation HUDView{
    CALayer *redLayer;
    CALayer *greenLayer;
    CALayer *blueLayer;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        redLayer = [[CALayer alloc]init];
        redLayer.frame = CGRectMake(0, 0, 20, 20);
        redLayer.backgroundColor = [UIColor redColor].CGColor;
        redLayer.cornerRadius = 10;
        [self.layer addSublayer:redLayer];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform.scale";
        animation.values = @[@1.0,@2.0,@1.0,@1.0,@1.0];
        animation.duration = 2.0;
        
        
        UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
        [bezierPath addArcWithCenter:CGPointMake(frame.size.width/2, frame.size.height/2) radius:30 startAngle:0 endAngle:M_PI*2 clockwise:true];
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
        keyAnimation.keyPath = @"position";
        keyAnimation.path = bezierPath.CGPath;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[animation,keyAnimation];
        group.duration = 2;
        group.repeatCount = INFINITY;
        [redLayer addAnimation:group forKey:@"red"];
        
        greenLayer = [[CALayer alloc]init];
        greenLayer.frame = CGRectMake(frame.size.height/2-10, frame.size.width/2-10, 20, 20);
        greenLayer.backgroundColor = [UIColor greenColor].CGColor;
        greenLayer.cornerRadius = 10;
        
        [self.layer addSublayer:greenLayer];
        
        CAKeyframeAnimation *animation_green = [CAKeyframeAnimation animation];
        animation_green.keyPath = @"transform.scale";
        animation_green.values = @[@2.0,@1.0,@1.0,@1.0,@2.0];
        animation_green.duration = 2.0;
        
        UIBezierPath *bezierPath_green = [[UIBezierPath alloc]init];
        [bezierPath_green addArcWithCenter:CGPointMake(frame.size.width/2, frame.size.height/2) radius:30 startAngle:(M_PI*2/3) endAngle:M_PI*2+(M_PI*2/3) clockwise:true];
        CAKeyframeAnimation *keyAnimation_green = [CAKeyframeAnimation animation];
        keyAnimation_green.keyPath = @"position";
        keyAnimation_green.path = bezierPath_green.CGPath;
        
        CAAnimationGroup *group_green = [CAAnimationGroup animation];
        group_green.animations = @[animation_green,keyAnimation_green];
        group_green.duration = 2;
        group_green.repeatCount = INFINITY;
        [greenLayer addAnimation:group_green forKey:@"green"];
        
        blueLayer = [[CALayer alloc]init];
        blueLayer.frame = CGRectMake(0, 0, 20, 20);
        blueLayer.backgroundColor = [UIColor blueColor].CGColor;
        blueLayer.cornerRadius = 10;
        [self.layer addSublayer:blueLayer];
        
        CAKeyframeAnimation *animation_blue = [CAKeyframeAnimation animation];
        animation_blue.keyPath = @"transform.scale";
        animation_blue.values = @[@1.0,@1.0,@1.0,@2.0,@1.0];
        animation_blue.duration = 2.0;
        
        UIBezierPath *bezierPath_blue = [[UIBezierPath alloc]init];
        [bezierPath_blue addArcWithCenter:CGPointMake(frame.size.width/2, frame.size.height/2) radius:30 startAngle:(M_PI*4/3) endAngle:M_PI*2+(M_PI*4/3) clockwise:true];
        CAKeyframeAnimation *keyAnimation_blue = [CAKeyframeAnimation animation];
        keyAnimation_blue.keyPath = @"position";
        keyAnimation_blue.path = bezierPath_blue.CGPath;
        
        CAAnimationGroup *group_blue = [CAAnimationGroup animation];
        group_blue.animations = @[animation_blue,keyAnimation_blue];
        group_blue.duration = 2;
        group_blue.repeatCount = INFINITY;
        [blueLayer addAnimation:group_blue forKey:@"blue"];

        
        
    }
    return self;
}

@end



@interface HUDViewController ()


@end

@implementation HUDViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[[HUDView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)]];
}

@end
