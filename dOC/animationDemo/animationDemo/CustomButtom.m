//
//  CustomButtom.m
//  animationDemo
//
//  Created by runo on 17/8/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "CustomButtom.h"

@implementation CustomButtom

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc]init];
        self.titleLabel = [[UILabel alloc]init];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}





@end
