//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by runo on 16/9/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**用于配置绘制的参数，例如文字颜色，大小，行间距等*/
@interface CTFrameParserConfig : NSObject

@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat fontSize;
@property(nonatomic,assign)CGFloat lineSpace;//!<行间距
@property(nonatomic,strong)UIColor *textColor;//!<文本颜色

@end
