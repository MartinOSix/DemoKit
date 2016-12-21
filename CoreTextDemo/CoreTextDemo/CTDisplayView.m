//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by runo on 16/9/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>


@implementation CTDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //翻转坐标系，
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    /*
    // Drawing code
    //得到当前绘制画布的上下文，用于后续将内容绘制在画布上
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //翻转坐标系，
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    NSAttributedString *attstring = [[NSAttributedString alloc]initWithString:@"Hello world!"
                        "创建绘制区域，COreText本身支持各种文字排版区域"
                                     "我们这里简单地将UIView的整几个界面作为排版的区域"
                        
                                     ];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attstring);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attstring length]), path, NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    */
}


@end

























