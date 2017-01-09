//
//  ViewController5.m
//  animationDemo
//
//  Created by runo on 16/9/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController5.h"
#import <UIKit/UIKit.h>


@interface ViewController5 ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) UIBezierPath *drawPath;
@property(nonatomic,assign) NSInteger count;

@end

@implementation ViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"clear" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 66, 70, 30);
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(cearPath) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
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
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    shapeLayer.name = @"path";
    
    
    [self.view.layer addSublayer:shapeLayer];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.drawPath = [[UIBezierPath alloc]init];
    CGPoint point = [[[touches allObjects] firstObject] locationInView:self.view];
    [self.drawPath moveToPoint:point];
    self.count++;
    NSLog(@"start %d",self.count);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[[touches allObjects] firstObject] locationInView:self.view];
    CGPoint cpoint = CGPointMake(point.x + 10, point.y+10);
    //画曲线，不知道怎么找控制点
    [self.drawPath addQuadCurveToPoint:point controlPoint:cpoint];
    //画直线
    //[self.drawPath addLineToPoint:point];
    //- (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;
    [self.drawPath moveToPoint:point];
    //NSLog(@"2  %@",NSStringFromCGPoint(point));
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = self.drawPath.CGPath;
    shapeLayer.name = [NSString stringWithFormat:@"path%ld",(long)self.count];
    NSLog(@"doing %ld",(long)self.count);
    for (CALayer *layer in self.view.layer.sublayers) {
        if([layer.name hasPrefix:[NSString stringWithFormat:@"path%ld",(long)self.count]]){
            [layer removeFromSuperlayer];
        }
    }
    NSLog(@"%d",self.view.layer.sublayers.count);
    [self.view.layer addSublayer:shapeLayer];
}

-(void)cearPath{
    
    for (int i = 0; i < self.view.layer.sublayers.count;) {
        CALayer *layer  = self.view.layer.sublayers[i];
        if([layer.name hasPrefix:@"path"]){
            [layer removeFromSuperlayer];
            continue;
        }
        i++;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

@end

















