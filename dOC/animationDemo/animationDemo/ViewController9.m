//
//  ViewController9.m
//  animationDemo
//
//  Created by runo on 16/9/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController9.h"
#import "BezierView.h"

@interface ViewController9 ()
@property(nonatomic,strong)UIView *colorView;
@property(nonatomic,strong)CALayer *colorLayer;
@property(nonatomic,strong)BezierView *bview;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation ViewController9

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //关键帧动画
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bview = [[BezierView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    self.bview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bview];
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(100, 100) controlPoint2:CGPointMake(100, 100)];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    //animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;

    
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"transform.rotation";
    //animation1.duration = 2.0;
    animation1.byValue = @(M_PI*2);//[NSValue valueWithCATransform3D:CATransform3DMakeRotation(2*M_PI, 0, 0, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,animation1];
    group.duration = 4.0;
    
    [self.bview.layer addAnimation:group forKey:nil];
}


-(void)test2{
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(100, 100) controlPoint2:CGPointMake(100, 100)];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    [self.bview.layer addAnimation:animation forKey:nil];
    
}

-(void)test1{
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //关键帧动画
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.colorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.view addSubview:view];
        view;
    });
    
    self.btn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 300, 100, 50);
        btn.backgroundColor = [UIColor redColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnCLick) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    _colorLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.colorView.layer addSublayer:_colorLayer];
    
    
}

-(void)btnCLick{

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 7.0;
    animation.values = @[(__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor
                         ];
    
    [self.colorLayer addAnimation:animation forKey:nil];
}


















@end
