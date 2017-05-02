//
//  ViewController.m
//  DynamicBehavior
//
//  Created by runo on 17/5/2.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UIDynamicAnimator *animator;
@property(nonatomic,strong) UIView *animView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:self.animView];
    self.animView.backgroundColor = [UIColor redColor];
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UIGravityBehavior *gravityB = [[UIGravityBehavior alloc]initWithItems:@[self.animView]];
    //方向
    gravityB.gravityDirection = CGVectorMake(0, -1);
    
    //角度
    gravityB.angle = M_PI_4;
    
    //加速度
    gravityB.magnitude = 10.0;
    [self.animator addBehavior:gravityB];
    // 创建碰撞仿真行为
    UICollisionBehavior *collisionB = [[UICollisionBehavior alloc] initWithItems:@[self.animView, self.view]];
    // 设置碰撞的边界
    //    collisionB.translatesReferenceBoundsIntoBoundary = YES;
    
    // 添加直线边界
    //    [collisionB addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(0, 200) toPoint:CGPointMake(320, 420)];
    
    // 添加图形的边界
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.view.frame];
    [collisionB addBoundaryWithIdentifier:@"abc" forPath:path];
    
    
    // 5.将物理仿真行为添加到仿真器中,self.dynamicAnimator为懒加载的物理仿真器对象
    [self.animator addBehavior:collisionB];
    
}

//捕捉行为
-(void)snapBehavior:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    UISnapBehavior *snapB = [[UISnapBehavior alloc]initWithItem:self.animView snapToPoint:point];
    snapB.damping = 0;
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snapB];
}

@end
