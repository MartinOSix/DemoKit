//
//  UIButton+CQButton.m
//  AVPlayer
//
//  Created by runo on 16/6/6.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "UIButton+CQButton.h"

@implementation UIButton (CQButton)

-(void)cqSetNormalTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)cqSetNormalTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
}
-(void)cqSetNormalTitleFont:(UIFont *)font{
    self.titleLabel.font = font;
}
-(void)cqSetNormalTitle:(NSString *)title Color:(UIColor *)color{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
}
-(void)cqSetNormalTitle:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    if (font) {
        self.titleLabel.font = font;
    }
}
-(void)cqSetFocusedTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateFocused];
}
-(void)cqSetHighlightedTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateHighlighted];
}
-(void)cqSetSelectedTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateSelected];
}
-(void)cqSetNormalBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}
-(void)cqSetSelectBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

-(void)cqSetNormalImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
}
-(void)cqSetSelectedImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateSelected];
}


@end
