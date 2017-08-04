//
//  CustomButtom.h
//  animationDemo
//
//  Created by runo on 17/8/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomButtom : UIControl

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLabel;


-(instancetype)initWithFrame:(CGRect)frame;

@end
