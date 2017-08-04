//
//  ViewController6.m
//  animationDemo
//
//  Created by runo on 16/9/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController6.h"

@interface ViewController6 ()

@end

@implementation ViewController6

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 500)];
    [self.view addSubview:view];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = view.bounds;
    [view.layer addSublayer:textLayer];
    
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    NSString *text = @"alsjdkfalsdfkjalskjfalsdkfjasldjflaksdfj";
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.string = text;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 120, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"哈哈哈哈" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:btn];
    
    //10是imageView与上面的边距，120是btn的宽度，100是高度
    CGSize imgSize = btn.imageView.bounds.size;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(10+10+imgSize.height, -imgSize.width, 0.0, 0.0)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, (120-imgSize.width)/2, 100-imgSize.height-10, (120-imgSize.width)/2);
    
    //btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
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
