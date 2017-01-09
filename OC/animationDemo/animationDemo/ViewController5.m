//
//  ViewController5.m
//  animationDemo
//
//  Created by runo on 16/9/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController5.h"

@interface ViewController5 ()


@end

@implementation ViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(175, 100)];
    
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 250)];
    [path addLineToPoint:CGPointMake(120, 280)];
    [path moveToPoint:CGPointMake(150, 250)];
    [path addLineToPoint:CGPointMake(180, 280)];
    [path moveToPoint:CGPointMake(120, 200)];
    [path addLineToPoint:CGPointMake(180, 200)];
    //[path moveToPoint:CGPointMake(150, 175)];
    //[path addLineToPoint:CGPointMake(100, 150)];
    //[path addLineToPoint:CGPointMake(200, 150)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

















