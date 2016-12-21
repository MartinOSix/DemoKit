//
//  UIImage+CQExtention.m
//  CQFramework
//
//  Created by runo on 16/11/30.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "UIImage+CQExtention.h"
#import <ImageIO/ImageIO.h>
#import "CQConstantDefine.h"
#import <MobileCoreServices/UTCoreTypes.h>
@implementation UIImage (CQExtention)

/**获取一个View控件的截屏*/
+(UIImage *)cqImageFormView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
/**根据颜色生成对应的图片*/
+(UIImage *)cqCreateImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1080, 1080);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}
/**修复手机拍照后上传服务器图片翻转的问题*/
+(UIImage *)cqFixOrientation:(UIImage *)aImage{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;

}


/**压缩图片  有点小问题不影响使用，详细看里面测试代码*/
-(UIImage *)cqCompressToLessThanKB:(CGFloat)maxSizeKb{
    
    
    //首先将图片弄成二进制
    NSData *pictureData=UIImageJPEGRepresentation(self, 1.0);
    
    CGFloat maxQuality = 1.0f;
    CGFloat currentSize = pictureData.length/1024.f;
    
    NSLog(@"2 %lf",currentSize);
    while (currentSize > maxSizeKb) {
        
        maxQuality = maxQuality - 0.1;
        if (maxQuality <= 0.1) {
            maxQuality = 0.1;
            break;
        }
        currentSize = UIImageJPEGRepresentation(self, maxQuality).length/1024.f;
        NSLog(@"while   max %.2f   currentsize %lf",maxQuality,currentSize);
    }
    NSLog(@"maxsize %.2f",maxQuality);
    /* 这里data转成image 再转回data之后变大了
    NSData *rData = UIImageJPEGRepresentation(self, maxQuality);
    UIImage *rimg = [UIImage imageWithData:UIImageJPEGRepresentation(self, maxQuality)];
    NSData *tData = UIImageJPEGRepresentation(rimg, 1.0);
    NSLog(@"%lf   %lf ",rData.length/1024.f,tData.length/1024.f);
    */
    return [UIImage imageWithData:UIImageJPEGRepresentation(self, maxQuality)];
    
    
}

/**图片旋转 参数是角度 方向：顺时针 */
-(UIImage *)cqImageRotatedByDegrees:(CGFloat)degrees{
    
    UIImage *image = [UIImage cqFixOrientation:self];
    
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), image.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}
/**图片切圆角*/
-(UIImage *)cqRoundedImage:(float)radius{
    
    CALayer *imageLayer = [CALayer layer];
    UIImage *image = [UIImage cqFixOrientation:self];
    
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}
/**重设图片缩放比例  0 ~ 1 */
-(UIImage *)cqScaleImageWithRate:(float)rate{
    
    //UIGraphicsBeginImageContext(CGSizeMake(self.size.width * rate, self.size.height * rate));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width * rate, self.size.height * rate), NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width * rate, self.size.height * rate)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
/**重设图片尺寸*/
-(UIImage *)cqResetImageSize:(CGSize)reSize{
    //UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height), NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

/**获取该图片的高斯模糊图片*/
- (void)cqCreateGaussianImageWithRadius:(float)radius Complete:(void(^)(UIImage *img))block{
    
    if (block == nil) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage,@"inputRadius", @(radius), nil];
        CIImage *outputImage = filter.outputImage;
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:outImage];
        CGImageRelease(outImage);
        dispatch_async(dispatch_get_main_queue(), ^{
            block(resultImage);
        });
    });
}
- (UIImage *)cqCreateGaussianImageWithRadius:(float)radius
{
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage,@"inputRadius", @(radius), nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return resultImage;
}
/**获取裁剪的部分图片*/
-(UIImage *)cqSubImageAtFrame:(CGRect)frame{
    
    frame = CGRectMake(frame.origin.x * self.scale, frame.origin.y * self.scale, frame.size.width * self.scale, frame.size.height * self.scale);
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, frame);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[self scale] orientation:[self imageOrientation]];
    CGImageRelease(newImageRef);
    return newImage;
}
/**添加一个image到这个image上*/
- (UIImage *)cqAddImageToImage:(UIImage *)img atRect:(CGRect)cropRect{
    
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [self drawAtPoint:pointImg1];
    //重设选中图片的大小
    img = [img cqResetImageSize:cropRect.size];
    
    CGPoint pointImg2 = cropRect.origin;
    [img drawAtPoint: pointImg2];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}
/**将自身填充到指定size  没搞懂，图像反倒是翻转了可能是坐标原点问题，也有可能是拍照图片和原始图片区别*/
- (UIImage *)cqFillClipSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(imageContext, (CGRect){CGPointZero, self.size}, [self CGImage]);
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
/**获取黑白图片*/
- (UIImage *)cqGrayScale{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 width,
                                                 height,
                                                 8, // bits per component
                                                 0,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:image];
    CFRelease(image);
    CGContextRelease(context);
    
    return grayImage;
}

/***************    GIF    *************< start >*************/
/**创建动态图*/
+(NSString *)cqCreateGIFWith:(NSArray<UIImage *> *)images Name:(NSString *)name{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *dbFile = [filePath stringByAppendingPathComponent:@"gitCache"];
    
    BOOL isDirectory = false;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dbFile isDirectory:&isDirectory];
    
    if (isExist == NO || !isDirectory) {
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager]createDirectoryAtPath:dbFile withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error != nil) {
            NSLog(@"%@",error);
            kfDebugLog(@"创建文件夹失败");
            return nil;
        }
        if (!result){
            return nil;
        }
        
    }
    
    NSString *path = dbFile;
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif",name]];
    //如果kUTTypeGif报错可能 导错了包
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], kUTTypeGIF, images.count, NULL);
    //一次循环持续时间
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.2f] forKey:(NSString *)kCGImagePropertyGIFDelayTime] forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //动态图循环次数，0次无限
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]forKey:(NSString *)kCGImagePropertyGIFDictionary];
    for (UIImage *image in images) {
        CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)frameProperties);
    }
    //CGImageDestinationAddImage(destination, bucho.CGImage, (CFDictionaryRef)frameProperties);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    BOOL result = CGImageDestinationFinalize(destination);
    CFRelease(destination);
    if (result) {
        NSLog(@"animated GIF file created at %@", path);
        return path;
    }else{
        return nil;
    }

}
/**解析Gif图片为图片数组*/
+(NSArray<UIImage *> *)cqParseGIFwithData:(NSData *)gifData{
    
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        marr = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [marr addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return [marr copy];
}
/**创建GIF图片*/
+ (UIImage *)cqAnimatedGIFWithData:(NSData *)data{
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self cqFrameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}
+ (float)cqFrameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
