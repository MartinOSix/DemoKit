//
//  WaveViewViewController.m
//  animationDemo
//
//  Created by runo on 17/6/30.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "WaveViewViewController.h"

#pragma mark - waveView

@interface WaveView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat wave_amplitude;//振幅a（y = asin(wx+φ) + k）
@property (nonatomic, assign) CGFloat wave_cycle;//周期w
@property (nonatomic, assign) CGFloat wave_h_distance;//两个波水平之间偏移
@property (nonatomic, assign) CGFloat wave_v_distance;//两个波竖直之间偏移
@property (nonatomic, assign) CGFloat wave_scale;//水波速率
@property (nonatomic, assign) CGFloat wave_offsety;//波峰所在位置的y坐标
@property (nonatomic, assign) CGFloat wave_move_width;//移动的距离，配合速率设置
@property (nonatomic, assign) CGFloat wave_offsetx;//偏移
@property (nonatomic, assign) CGFloat offsety_scale;//上升的速度

@end

@implementation WaveView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        //初始化信息
        [self initInfo];
    }
    return self;
}

-(void)initInfo{
    
    //y=Asin(ωx+φ)+k
    _wave_amplitude = 5;
    
    _wave_cycle = M_PI*4/(self.frame.size.width);
    
    _wave_offsety = self.frame.size.height;
    
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(addProgress)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)addProgress{
    
    NSLog(@"addProgress");
    _wave_offsetx += _wave_cycle*2;//速度
    _wave_offsety -= 0.1;
    if (_wave_offsety <= 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [[UIColor groupTableViewBackgroundColor] setFill];
    [path fill];
    [path addClip];
    CGFloat offsetx1 = 0;
    CGFloat offsetx2 = 2 * M_PI / _wave_cycle * 0.6;
    int offsety = _wave_offsety;
    //offsetx += 0.1;
    //绘制两个波形图
    [self drawWaveColor:[UIColor blueColor] offsetx:offsetx1 offsety:offsety];
    [self drawWaveColor:[UIColor cyanColor] offsetx:offsetx2 offsety:offsety];
    
}

- (void)drawWaveColor:(UIColor *)color offsetx:(CGFloat)offsetx offsety:(CGFloat)offsety
{
    
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    [wavePath moveToPoint:CGPointMake(0, _wave_offsety)];
    CGFloat y = _wave_offsety;
    for (float x = 0.0f; x <= self.frame.size.width ; x++) {
        
        //y=Asin(ωx+φ)+k
        //_wave_amplitude 表示波峰到波谷的间距
        //_wave_cycle 表示单位x内周期的个数（2π/width）表示在width宽度里面有一个周期
        //_wave_offsetx+offsetx 表示在x轴上的便宜量
        //表示距离原点的偏移量
        y = _wave_amplitude * sin(_wave_cycle * x+_wave_offsetx+offsetx)+offsety;
        [wavePath addLineToPoint:CGPointMake(x, y)];
    }
    [wavePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [wavePath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [wavePath closePath];
    [color set];
    [wavePath fill];
}

@end


#pragma mark - WaveViewViewController
@interface WaveViewViewController ()

@end

@implementation WaveViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    WaveView *view = [[WaveView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.layer.cornerRadius = 50;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
