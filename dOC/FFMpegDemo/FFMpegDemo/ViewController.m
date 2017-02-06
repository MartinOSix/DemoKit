//
//  ViewController.m
//  FFMpegDemo
//
//  Created by runo on 17/1/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "avformat.h"
#import "swresample.h"
#import "swscale.h"
#import "pixdesc.h"

#define kCheckError if (_hasError) {\
return;\
}

typedef NS_ENUM(NSUInteger, VideoFrameType) {
    VideoFrameTypeYUV,
    VideoFrameTypeRGB
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

@interface ViewController ()

@property(nonatomic,readonly) CGFloat fps;//!< 只读fps
@property (readonly, nonatomic) NSUInteger frameWidth;
@property (readonly, nonatomic) NSUInteger frameHeight;

@end

@implementation ViewController{
    
    AVFormatContext     *_formatCtx;//!<f视频上下文,f视频代表文件，v视频代表 视频流的视频不包含声音
    AVCodecContext      *_videoCodecCtx;//!<v视频流上下文
    AVFrame             *_videoFrame;//!<v视频帧
    VideoFrameType      _videoFrameType;//!<视频帧类型
    CGFloat             *_videoTimeBase;//!<应该是一帧的时间单位
    NSInteger           _videoStream;//!<正在打开的v视频流
    NSArray             *_videoStreams;//!<v视频流所在文件中的位置，能打开的视频流
    
    NSInteger           _audioStream;//!<正在打开的a音频流
    NSArray             *_audioStreams;//!<能打开的音频流
    
    NSUInteger          _artworkStream;//!<v视频流中的插图流？，反正不是正在读的
    BOOL                _hasError;
    BOOL                _hasVideoError;
    BOOL                _hasAudioError;
    BOOL                _isEOF;
    
}

#pragma mark - Get and Set

-(NSUInteger)frameWidth{
    return _videoCodecCtx?_videoCodecCtx->width:0;
}

-(NSUInteger)frameHeight{
    return _videoCodecCtx?_videoCodecCtx->height:0;
}
#pragma mark main
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFFmpegTool];
    
    _hasError = NO;
    NSString *path = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    //path = @"rtsp://admin:admin@192.168.100.1:554/cam1/h264";
    //path = [[NSBundle mainBundle]pathForResource:@"static" ofType:@"mov"];
    
    [self openFileWithPath:path];
    [self openVideoStream];
}

-(CQMovieError)openVideoStream{
    
    CQMovieError errorCode = CQMovieErrorStreamNotFount;
    _videoStreams = collectStreams(_formatCtx, AVMEDIA_TYPE_VIDEO);
    for (NSNumber *loc in _videoStreams) {
        const NSUInteger iStream = loc.integerValue;
        if (0==(_formatCtx->streams[iStream]->disposition & AV_DISPOSITION_ATTACHED_PIC)) {
            errorCode = [self openVideoStreamAt:iStream];
        }else{
            _artworkStream = iStream;
        }
    }
    return errorCode;
}

//打开指定位置的视频流
-(CQMovieError)openVideoStreamAt:(NSInteger)index{
    
    //获取f视频上下文中的v视频流中的解码器上下文
    AVCodecContext *codecCtx = _formatCtx->streams[index]->codec;
    //发现上下文中的解码器
    AVCodec *codec = avcodec_find_decoder(codecCtx->codec_id);
    if (!codec) {
        return CQMovieErrorCodecNotFount;
    }
    //打开解码器
    if(avcodec_open2(codecCtx, codec, NULL) < 0){
        return CQMovieErrorOpenCodec;
    }
    //创建v视频帧
    _videoFrame = av_frame_alloc();
    if (!_videoFrame) {
        avcodec_close(codecCtx);
        return CQMovieErrorAllocateFrame;
    }
    _videoStream = index;
    _videoCodecCtx = codecCtx;
    //获取指定的v视频流
    AVStream *st = _formatCtx->streams[_videoStream];
    avStreamFPSTimeBase(st, 0.04, &_fps, &_videoTimeBase);
    NSLog(@"1 video codec size %d : %d fps: %.3f tb: %f",self.frameWidth,self.frameHeight,_fps,_videoTimeBase);
    NSLog(@"decode stream");
    
    if (_videoCodecCtx && (_videoCodecCtx->pix_fmt == AV_PIX_FMT_YUV420P || _videoCodecCtx->pix_fmt == AV_PIX_FMT_YUVJ420P) ) {
        
        _videoFrameType = VideoFrameTypeYUV;
    }else{
        _videoFrameType = VideoFrameTypeRGB;
    }
    
    [self decodeVideoStream];
    return CQMovieErrorNone;
}

//从视频流中解码出数据
-(void)decodeVideoStream{
    
    
    NSMutableArray *result = [NSMutableArray array];
    AVPacket packet;
    CGFloat decodedDuration = 0;
    BOOL finished = NO;
    
    while (!finished) {
        
        if (av_read_frame(_formatCtx, &packet) < 0) {
            _isEOF = YES;
            break;
        }
        
        if (packet.stream_index ==_videoStream) {
            
            int pktSize = packet.size;
            while (pktSize > 0) {
                int gotframe = 0;
                int len = avcodec_decode_video2(_videoCodecCtx,
                                                _videoFrame,
                                                &gotframe,
                                                &packet);
                if (len < 0) {
                    NSLog(@"0  decode video error, skip packet");
                    break;
                }
                if (gotframe) {
                    NSLog(@"getframe");
                    if (!_videoFrame->data[0])
                        return ;
                }
            }
            
        }
    }
    
}

-(CQMovieError)openAudioStream{
    
    CQMovieError errCode = CQMovieErrorStreamNotFount;
    _audioStream = -1;
    _audioStreams = collectStreams(_formatCtx, AVMEDIA_TYPE_AUDIO);
    
    for (NSNumber *n in _audioStreams) {
        errCode = [self openAudioStream:n.integerValue];
        if (errCode == CQMovieErrorNone) {
            break;
        }
    }
    return errCode;
}

-(CQMovieError)openAudioStream:(NSInteger )index{
    
    AVCodecContext *codecCtx = _formatCtx->streams[index]->codec;
    //这个不知道
    SwrContext *swrContext = NULL;
    AVCodec *codec = avcodec_find_decoder(codecCtx->codec_id);
    if(!codec){
        return CQMovieErrorCodecNotFount;
    }
    if (avcodec_open2(codecCtx, codec, NULL) < 0) {
        return CQMovieErrorOpenCodec;
    }
    return CQMovieErrorNone;
}

-(CQMovieError)openFileWithPath:(NSString *)path{
    
    //
    avformat_network_init();
    //format上下文
    AVFormatContext *formatCtx = avformat_alloc_context();
    if (!formatCtx) {
        NSLog(@"open fail with path %@",path);
        _hasError = YES;
        return CQMovieErrorAllocateFormatContext;
    }
    
    //中断回调
    AVIOInterruptCB cb = {interruptCallBack,(__bridge void *)(self)};
    //formatCtx->interrupt_callback = cb;
    
    //打开文件,返回0成功，返回负数失败
    int openfileCode = avformat_open_input(&formatCtx, [path cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL);
    if(openfileCode < 0){
        _hasError = YES;
        if (formatCtx) {
            avformat_free_context(formatCtx);
        }
        char errbuf[1024] = "";
        av_strerror(openfileCode, &errbuf, 1024);//错误信息
        NSLog(@"open fail with formatCtx open input %s",errbuf);
        return CQMovieErrorStreamInfoNotFound;
    }
    formatCtx->interrupt_callback = cb;
    //从打开的文件中查找流
    if(avformat_find_stream_info(formatCtx, NULL)<0){
        _hasError = YES;
        avformat_close_input(&formatCtx);
        NSLog(@"find stream fail");
        return CQMovieErrorStreamInfoNotFound;
    }
    //感觉是打印数据
    av_dump_format(formatCtx, 0, [path.lastPathComponent cStringUsingEncoding:NSUTF8StringEncoding], false);
    
    _formatCtx = formatCtx;
    return CQMovieErrorNone;
}

-(void)setupFFmpegTool{
    av_register_all();
    av_log_set_callback(FFLog);
    avformat_network_init();
}

- (BOOL) interruptDecoder
{
    if (_hasError) {
        return YES;
    }
    return NO;
}
#pragma mark - C funtion

static BOOL audioCodecIsSupported(AVCodecContext *audio){
    return NO;
}

/**获取v视频流中fps 和 时间单位*/
static void avStreamFPSTimeBase(AVStream *st,CGFloat defaultTimeBase,CGFloat *pFPS,CGFloat *pTimeBase){
    CGFloat fps,timebase;
    if(st->time_base.den && st->time_base.num){
        timebase = av_q2d(st->time_base);
    }else if (st->codec->time_base.den && st->codec->time_base.num){
        timebase = av_q2d(st->codec->time_base);
    }else{
        timebase = defaultTimeBase;
    }
    
    if (st->codec->ticks_per_frame != 1) {
        NSLog(@"ffmpeg warning:st.code.ticks_per_frame = %d",st->codec->ticks_per_frame);
    }
    
    if (st->avg_frame_rate.den && st->avg_frame_rate.num) {
        fps = av_q2d(st->avg_frame_rate);
    }else if (st->r_frame_rate.den && st->r_frame_rate.num){
        fps = av_q2d(st->r_frame_rate);
    }else{
        fps = 1.0/timebase;
    }
    
    if (pFPS) {
        *pFPS = fps;
    }
    if (pTimeBase) {
        *pTimeBase = timebase;
    }
}

//从f视频上下文中获取里面指定的媒体流类型位置
static NSArray * collectStreams(AVFormatContext *formatCtx,enum AVMediaType type){
    NSMutableArray *marr = [NSMutableArray array];
    for (NSInteger i = 0; i < formatCtx->nb_streams; ++i) {
        if (type == formatCtx->streams[i]->codec->codec_type) {
            [marr addObject:[NSNumber numberWithInteger:i]];
        }
    }
    return [marr copy];
}

//进这个方法代表ffmpeg告诉你处理被中断了
static int interruptCallBack(void *backCtx){
    if (!backCtx) {
        return 0;
    }
    __unsafe_unretained ViewController *vc = (__bridge ViewController *)backCtx;
    const BOOL r = [vc interruptDecoder];
    if (r) NSLog(@"1 DEBUG: INTERRUPT_CALLBACK!");
    return r;
}

#pragma mark ffmpegLog
static void FFLog(void* context, int level, const char* format, va_list args) {
    @autoreleasepool {
        //Trim time at the beginning and new line at the end
        NSString* message = [[NSString alloc] initWithFormat: [NSString stringWithUTF8String: format] arguments: args];
        switch (level) {
            case 0:
            case 1:
                NSLog(@"leve 0 %@",[message stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
                break;
            case 2:
                NSLog(@"leve 1 %@",[message stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
                break;
            case 3:
            case 4:
                NSLog(@"leve 2 %@",[message stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
                break;
            default:
                //NSLog(@"leve 3 %@",[message stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]);
                break;
        }
    }
}

@end
