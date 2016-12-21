//
//  BezierView.m
//  animationDemo
//
//  Created by runo on 16/9/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "BezierView.h"

@implementation BezierView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
 - (void)drawRect:(CGRect)rect {
     [self drawTrianglePath];
     
}

- (void)drawTrianglePath{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    
    //最后闭合线是可以通过closePath方法自动生成，也可以调用addLineToPoint方法来添加
    [path closePath];
    
    path.lineWidth = 1.5;
    //设置填充颜色
    UIColor *fillColor = [UIColor greenColor];
    [fillColor set];
    [path fill];
    //设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    [strokeColor set];
    
    //根据我们设置的各个点连线
    [path stroke];
    
}
























@end
