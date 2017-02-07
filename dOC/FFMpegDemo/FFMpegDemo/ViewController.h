//
//  ViewController.h
//  FFMpegDemo
//
//  Created by runo on 17/1/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VideoFrameType) {
    VideoFrameTypeYUV,
    VideoFrameTypeRGB
};

typedef NS_ENUM(NSUInteger, MovieFrameType) {
    MovieFrameTypeAudio,
    MovieFrameTypeVideo,
    MovieFrameTypeArtwork,
    MovieFrameTypeSubtitle
};


typedef NS_ENUM(NSUInteger, CQMovieError) {
    CQMovieErrorCodecNotFount,//没有发现解码器
    CQMovieErrorStreamNotFount,//没有发现媒体流
    CQMovieErrorOpenCodec,//打开解码器失败
    CQMovieErrorOpenFile,//打开文件失败地址那里
    CQMovieErrorStreamInfoNotFound,//在f视频上下文中发现流失败
    CQMovieErrorAllocateFormatContext,//创建f视频上下文失败
    CQMovieErrorAllocateFrame,//创建v视频帧失败
    CQMovieErrorNone//没有错误
    
};

@interface MovieFrame : NSObject

@property (readwrite, nonatomic) MovieFrameType type;
@property (readwrite, nonatomic) CGFloat position;
@property (readwrite, nonatomic) CGFloat duration;

@end

@interface VideoFrame : MovieFrame

@property (readwrite, nonatomic) VideoFrameType format;
@property (readwrite, nonatomic) NSUInteger width;
@property (readwrite, nonatomic) NSUInteger height;

@end

@interface VideoFrameYUV : VideoFrame//在外部是只读属性
@property (readwrite, nonatomic, strong) NSData *luma;
@property (readwrite, nonatomic, strong) NSData *chromaB;
@property (readwrite, nonatomic, strong) NSData *chromaR;
@end

@interface VideoFrameRGB : VideoFrame
@property (readonly, nonatomic) NSUInteger linesize;
@property (readonly, nonatomic, strong) NSData *rgb;
- (UIImage *) asImage;
@end

@interface ViewController : UIViewController


@end

