//
//  CQCheckButton.m
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQCheckButton.h"
#import "Masonry.h"
#import "UIView+CQExtension.h"
#import "NSString+CQExtension.h"

@interface CQCheckButton ()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLabel;

@end


@implementation CQCheckButton

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    _cqTitle = title;
    _cqIsSelected = NO;
    _cqCanTouchChange = YES;
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"checkbox_no"];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(10);
            make.height.offset(10);
            make.left.offset(5);
            make.centerY.equalTo(self.mas_centerY);
        }];
        imageView;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        [self addSubview:label];
        label.text = title;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.equalTo(_imageView.mas_right).offset(5);
            make.right.mas_lessThanOrEqualTo(self).offset(5);
        }];
        [label cqShowBorderWithColor:[UIColor blackColor]];
        label;
    });
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClcik)];
    [self addGestureRecognizer:tap];
    return self;
}

-(void)tapClcik{
    
    if(_cqCanTouchChange){
        if (_cqIsSelected) {
            self.imageView.image = self.cqNormalImg?self.cqNormalImg:[UIImage imageNamed:@"checkbox_no"];
            _cqIsSelected = NO;
        }else{
            self.imageView.image = self.cqSelectImg?self.cqSelectImg:[UIImage imageNamed:@"checkbox_yes"];
            _cqIsSelected = YES;
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (_cqIsSelected && self.cqSelectTitleColor) {
        self.titleLabel.textColor = self.cqSelectTitleColor;
    }else{
        self.titleLabel.textColor = self.cqTitleColor;
    }
}

-(void)setCqIsSelected:(BOOL)cqIsSelected{
    
    if (cqIsSelected == _cqIsSelected) {
        return;
    }
    if (cqIsSelected) {
        self.imageView.image = self.cqSelectImg?self.cqSelectImg:[UIImage imageNamed:@"checkbox_yes"];
        _cqIsSelected = YES;
    }else{
        self.imageView.image = self.cqNormalImg?self.cqNormalImg:[UIImage imageNamed:@"checkbox_no"];
        _cqIsSelected = NO;
    }
    
}

-(void)setCqNormalImg:(UIImage *)cqNormalImg{
    _cqNormalImg = cqNormalImg;
    if (!self.cqIsSelected) {
        self.imageView.image = cqNormalImg;
    }
}

-(void)setCqSelectImg:(UIImage *)cqSelectImg{
    _cqSelectImg = cqSelectImg;
    if (self.cqIsSelected) {
        self.imageView.image = cqSelectImg;
    }
}

-(void)setCqTitleColor:(UIColor *)cqTitleColor{
    
    self.titleLabel.textColor = cqTitleColor;
    _cqTitleColor = cqTitleColor;
}
-(void)setCqSelectTitleColor:(UIColor *)cqSelectTitleColor{
    _cqSelectTitleColor = cqSelectTitleColor;
    if (self.cqIsSelected) {
        self.titleLabel.textColor = cqSelectTitleColor;
    }
}

-(void)setCqTitle:(NSString *)cqTitle{
    self.titleLabel.text = cqTitle;
    _cqTitle = cqTitle;
}

+(CGFloat)CQCheckButtonWidtdWithTitle:(NSString *)title{
    
    CGSize titleSize = [title cqStringSize:CGSizeMake(0, 20) FontSize:16];
    return titleSize.width+25;
}

-(CGFloat)cqCheckButtonWidthWidth{
    
    CGSize titleSize = [self.cqTitle cqStringSize:CGSizeMake(0, 20) FontSize:(self.cqTitleFont?self.cqTitleFont.pointSize:16)];
    self.cqFrame_width = titleSize.width+20+_imageView.cqFrame_width;
    return titleSize.width+20+_imageView.cqFrame_width;
}
-(void)setCqTitleFont:(UIFont *)cqTitleFont{
    self.titleLabel.font = cqTitleFont;
    _cqTitleFont = cqTitleFont;
}

-(void)setIconHeight:(CGFloat)iconHeight{
    
    _imageView.cqFrame_size = CGSizeMake(iconHeight, iconHeight);
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(iconHeight);
        make.height.offset(iconHeight);
        make.left.offset(5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    _iconHeight = iconHeight;
    
}

@end
