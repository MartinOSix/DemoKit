//
//  UIImage+CQExtention.h
//  CQFramework
//
//  Created by runo on 16/11/30.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**所有的图片修改都要注意一点，若是手机拍照的图片可能会导致图片方向丢失*/
@interface UIImage (CQExtention)

/**获取一个View控件的截屏*/
+(UIImage *)cqImageFormView:(UIView *)view;
/**根据颜色生成对应的图片*/
+(UIImage *)cqCreateImageWithColor:(UIColor *)color;
/**修复手机拍照后上传服务器图片翻转的问题*/
+(UIImage *)cqFixOrientation:(UIImage *)aImage;

#pragma mark 修改图片参数
-(UIImage *)cqCompressToLessThanKB:(CGFloat)maxSizeKb;
-(UIImage *)cqImageRotatedByDegrees:(CGFloat)degrees;
-(UIImage *)cqRoundedImage:(float)radius;
-(UIImage *)cqScaleImageWithRate:(float)rate;
-(UIImage *)cqResetImageSize:(CGSize)reSize;

/**获取该图片的高斯模糊图片*/
- (void)cqCreateGaussianImageWithRadius:(float)radius Complete:(void(^)(UIImage *img))block;
/**获取裁剪的部分图片*/
-(UIImage *)cqSubImageAtFrame:(CGRect)frame;
/**添加一个image到这个image上*/
- (UIImage *)cqAddImageToImage:(UIImage *)img atRect:(CGRect)cropRect;
/**将自身填充到指定size  没搞懂，图像反倒是翻转了*/
- (UIImage *)cqFillClipSize:(CGSize)size;
/**获取黑白图片*/
- (UIImage *)cqGrayScale;

/***************    GIF    *************< start >*************/
/**创建动态图*/
+(NSString *)cqCreateGIFWith:(NSArray<UIImage *> *)images Name:(NSString *)name;
/**解析Gif图片为图片数组*/
+(NSArray<UIImage *> *)cqParseGIFwithData:(NSData *)gifData;
/**创建GIF图片*/
+ (UIImage *)cqAnimatedGIFWithData:(NSData *)data;


@end
