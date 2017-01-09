//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by runo on 16/9/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CTFrameParserConfig.h"
///用于配置绘制的参数，例如文字颜色，大小，行间距等
@implementation CTFrameParserConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor colorWithRed:108/255.0f green:108/255.0f blue:108/255.0f alpha:1.0f];
    }
    return self;
}

@end
