//
//  ViewController.m
//  animationDemo
//
//  Created by runo on 16/9/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "NSDate+CQDate.h"

@interface ViewController ()<CALayerDelegate>

@property(nonatomic,strong) UIView *layerView;
@property(nonatomic,strong) UIImageView *clockImg;//!<中表盘
@property(nonatomic,strong) UIImageView *hourImg;//!<时
@property(nonatomic,strong) UIImageView *minImg;//!<分
@property(nonatomic,strong) UIImageView *secImg;//!<秒
@property(nonatomic,strong) NSTimer *timer;//!<定时器
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view1.layer.shadowOpacity = 0.5f;
    self.view2.layer.shadowOpacity = 0.5f;
    
    //create a square shadow
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, self.view1.bounds);
    self.view1.layer.shadowPath = squarePath;
    CGPathRelease(squarePath);
    
    //create a circular shadow
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.view2.bounds);
    self.view2.layer.shadowPath = circlePath;
    self.view2.layer.shadowOffset = CGSizeMake(0, 130);
    CGPathRelease(circlePath);
    
    
}

-(void)test2{
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.clockImg = ({
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 380, 380)];
        imgv.image = [UIImage imageNamed:@"clock.png"];
        
        [self.view addSubview:imgv];
        imgv;
    });
    
    self.hourImg = ({
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 150)];
        imgv.image = [UIImage imageNamed:@"hourArrow.png"];
        imgv.center = CGPointMake(380/2.0f, (380/2.0f));
        imgv.layer.anchorPoint = CGPointMake(0.5f, 0.8f);
        [self.clockImg addSubview:imgv];
        imgv;
    });
    
    self.minImg = ({
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 36, 176)];
        imgv.image = [UIImage imageNamed:@"minArrow.png"];
        imgv.center = CGPointMake(380/2.0f-5, (380/2.0f));
        imgv.layer.anchorPoint = CGPointMake(0.5f, 0.8f);
        [self.clockImg addSubview:imgv];
        imgv;
    });
    
    self.secImg = ({
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 21, 166)];
        imgv.image = [UIImage imageNamed:@"secArrow.png"];
        imgv.center = CGPointMake(380/2.0f, (380/2.0f));
        imgv.layer.anchorPoint = CGPointMake(0.5f, 0.8f);
        [self.clockImg addSubview:imgv];
        imgv;
    });
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [self tick];
}

-(void)tick{
    
    NSDate *nowDate = [NSDate date];
    CGFloat hoursAngle = (nowDate.cqHour/12.0f)*M_PI*2.0;
    CGFloat minAngle = (nowDate.cqMinute/60.0f)*2.0*M_PI;
    hoursAngle += minAngle * 0.12f;
    CGFloat secAngle = (nowDate.cqSecond/60.0f)*M_PI*2.0;
    self.hourImg.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.secImg.transform = CGAffineTransformMakeRotation(secAngle);
    self.minImg.transform = CGAffineTransformMakeRotation(minAngle);
}




-(void)test3{
    self.layerView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        view.backgroundColor = [UIColor whiteColor];
        view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        [self.view addSubview:view];
        view;
    });
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    NSLog(@"%@",NSStringFromCGRect(blueLayer.frame));
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    blueLayer.anchorPoint = CGPointMake(0, 0);
    NSLog(@"%@",NSStringFromCGRect(blueLayer.frame));
    [self.layerView.layer addSublayer:blueLayer];
    
    [blueLayer display];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

-(void)test1{
    UIImage *image = [UIImage imageNamed:@"img1.png"];
    
    CALayer *blueLyer = [CALayer layer];
    blueLyer.frame = CGRectMake(0.0f, 0.0f, 200.0f, 200.0f);
    //blueLyer.backgroundColor = [UIColor blueColor].CGColor;
    blueLyer.contents = (__bridge id)image.CGImage;
    blueLyer.contentsGravity = kCAGravityResizeAspect;
    blueLyer.masksToBounds = YES;
    blueLyer.contentsCenter = CGRectMake(0.25, 0.25, 0.2,0.2);
    //blueLyer.contentsRect = CGRectMake(0.5, 0, 0.5, 0.5);
    [self.layerView.layer addSublayer:blueLyer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
