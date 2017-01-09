//
//  ViewController4.m
//  animationDemo
//
//  Created by runo on 16/9/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController4.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 0,1,-0.5
#define AMBIENT_LIGHT 0.5

@interface ViewController4 ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *view1;
@property (weak, nonatomic) IBOutlet UIView *contaner;

@end

@implementation ViewController4{
    CATransform3D _perspectivce;
}


-(void)applyLightingToFace:(CALayer *)face{
    
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CATransform3D perspectivce = CATransform3DIdentity;
    perspectivce.m34 = -1.0/500.0;
    self.contaner.layer.sublayerTransform = perspectivce;
    _perspectivce = perspectivce;
    
    
    perspectivce = CATransform3DRotate(perspectivce, -M_PI_4, 1, 0, 0);
    perspectivce = CATransform3DRotate(perspectivce, -M_PI_4, 0, 1, 0);
    self.contaner.layer.sublayerTransform = perspectivce;

    
    CATransform3D tran = CATransform3DMakeTranslation(0, 0, 50);
    [self addFace:0 withTransform:tran];
    
    tran = CATransform3DMakeTranslation(50, 0, 0);
    tran = CATransform3DRotate(tran, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:tran];
    
    tran = CATransform3DMakeTranslation(0, -50, 0);
    tran = CATransform3DRotate(tran, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:tran];
    
    tran = CATransform3DMakeTranslation(0, 50, 0);
    tran = CATransform3DRotate(tran, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:tran];
    
    tran = CATransform3DMakeTranslation(-50, 0, 0);
    tran = CATransform3DRotate(tran, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:tran];
    
    tran = CATransform3DMakeTranslation(0, 0, -50);
    tran = CATransform3DRotate(tran, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:tran];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)];
    [self.view addGestureRecognizer:pan];
}

-(void)gesture:(UIPanGestureRecognizer *)pan{
    
    CGPoint p = [pan translationInView:self.view];//获取偏移量
    NSLog(@"%@",NSStringFromCGPoint(p));
    [pan setTranslation:CGPointZero inView:self.view];
    //x 偏移，旋转的是y轴
    CGFloat rx = (p.x/2000)*(M_PI)*10;
    _perspectivce = CATransform3DRotate(_perspectivce, rx, 0, 1, 0);
    //y 偏移，旋转的是x轴
    CGFloat ry = (p.y/2000)*(M_PI)*10;
    _perspectivce = CATransform3DRotate(_perspectivce, ry, 1, 0, 0);
    
    CGFloat rz = (sqrt(p.y*p.y + p.x*p.x)/2000)*(M_PI);
    _perspectivce = CATransform3DRotate(_perspectivce, rz, 0, 0, 1);
    
    self.contaner.layer.sublayerTransform = _perspectivce;
}

-(void)addFace:(NSInteger)index withTransform:(CATransform3D)tran{
    
    UIView *face = self.view1[index];
    [self.contaner addSubview:face];
    CGSize containerSize = self.contaner.bounds.size;
    face.center = CGPointMake(containerSize.width/2.0f, containerSize.height/2.0f);
    face.layer.transform = tran;
    [self applyLightingToFace:face.layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
