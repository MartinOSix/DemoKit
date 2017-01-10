//
//  ViewController7.m
//  animationDemo
//
//  Created by runo on 16/9/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController7.h"

@interface ViewController7 ()

@property(nonatomic,strong) UIView *containerView;


@end

@implementation ViewController7

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.containerView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
        [self.view addSubview:view];
        view;
    });
    
    //设置远点视图，相当于从右上角看屏幕
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0/500.0;
    self.containerView.layer.sublayerTransform = pt;
    
    //第一个立体layer
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.containerView.layer addSublayer:cube1];
    
    //第二个立体layer
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube2];
    
    
    // rCATransform3D ct = CATransform3DIdentity;
    //ct = CATransform3DRotate(ct, -M_PI_2*0.6, 1, 0, 0);
    //self.containerView.layer.transform = ct;
    
}

-(CALayer *)cubeWithTransform:(CATransform3D)transofrm{
    CATransformLayer *cube = [CATransformLayer layer];
    
    //默认正面朝你
    
    //正面,z轴上抬50°
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //右面,x轴右移50，顺时针90°
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //下面，y轴下移50，顺时针90
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //上面,y轴上移50，逆时针90
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //左面，x轴左移50，逆时针90
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //后面，z轴下沉50，顺时针180
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    CGSize containerSize = self.containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width/2.0, containerSize.height/2.0);
    cube.transform = transofrm;
    return cube;
}

-(CALayer *)faceWithTransform:(CATransform3D)transform{
    
    //创建一个立方体layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    //随机颜色
    face.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1].CGColor;
    //layer进行相应的3D转换
    face.transform = transform;
    return face;
    
}










@end
