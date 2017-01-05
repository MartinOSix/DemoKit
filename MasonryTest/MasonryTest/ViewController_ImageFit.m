//
//  ViewController_ImageFit.m
//  MasonryTest
//
//  Created by runo on 17/1/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController_ImageFit.h"

@interface ViewController_ImageFit ()

@end

@implementation ViewController_ImageFit

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //得到的尺寸
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 50, 200, 100);
    UIImage *image = [UIImage imageNamed:@"img"];
    // 1x1拉伸
    //image = [image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:image.size.height/2.0f];
    // 不等比拉伸
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 5, 5, 5);
    image = [image resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
}

@end
