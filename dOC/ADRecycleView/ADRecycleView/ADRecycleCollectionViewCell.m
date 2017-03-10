//
//  ADRecycleCollectionViewCell.m
//  ADRecycleView
//
//  Created by runo on 17/3/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ADRecycleCollectionViewCell.h"

@implementation ADRecycleCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_adImageView];
    }
    return self;
}

@end
