//
//  ViewController.m
//  FFMpegDemo
//
//  Created by runo on 17/1/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "avformat.h"
#import "avcodec.h"
#import "swresample.h"
#import "swscale.h"
#import "pixdesc.h"
#import "KxMovieGLView.h"
#define kCheckError if (_hasError) {\
return;\
}

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@implementation MovieFrame
@end


@implementation VideoFrame
-(MovieFrameType)type{return MovieFrameTypeVideo;}
@end


@implementation VideoFrameYUV
- (VideoFrameType) format { return VideoFrameTypeYUV; }
@end

@implementation KxMovieSubtitleASSParser

+ (NSArray *) parseEvents: (NSString *) events
{
    NSRange r = [events rangeOfString:@"[Events]"];
    if (r.location != NSNotFound) {
        
        NSUInteger pos = r.location + r.length;
        
        r = [events rangeOfString:@"Format:"
                          options:0
                            range:NSMakeRange(pos, events.length - pos)];
        
        if (r.location != NSNotFound) {
            
            pos = r.location + r.length;
            r = [events rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]
                                        options:0
                                          range:NSMakeRange(pos, events.length - pos)];
            
            if (r.location != NSNotFound) {
                
                NSString *format = [events substringWithRange:NSMakeRange(pos, r.location - pos)];
                NSArray *fields = [format componentsSeparatedByString:@","];
                if (fields.count > 0) {
                    
                    NSCharacterSet *ws = [NSCharacterSet whitespaceCharacterSet];
                    NSMutableArray *ma = [NSMutableArray array];
                    for (NSString *s in fields) {
                        [ma addObject:[s stringByTrimmingCharactersInSet:ws]];
                    }
                    return ma;
                }
            }
        }
    }
    
    return nil;
}

+ (NSArray *) parseDialogue: (NSString *) dialogue
                  numFields: (NSUInteger) numFields
{
    if ([dialogue hasPrefix:@"Dialogue:"]) {
        
        NSMutableArray *ma = [NSMutableArray array];
        
        NSRange r = {@"Dialogue:".length, 0};
        NSUInteger n = 0;
        
        while (r.location != NSNotFound && n++ < numFields) {
            
            const NSUInteger pos = r.location + r.length;
            
            r = [dialogue rangeOfString:@","
                                options:0
                                  range:NSMakeRange(pos, dialogue.length - pos)];
            
            const NSUInteger len = r.location == NSNotFound ? dialogue.length - pos : r.location - pos;
            NSString *p = [dialogue substringWithRange:NSMakeRange(pos, len)];
            p = [p stringByReplacingOccurrencesOfString:@"\\N" withString:@"\n"];
            [ma addObject: p];
        }
        
        return ma;
    }
    
    return nil;
}

+ (NSString *) removeCommandsFromEventText: (NSString *) text
{
    NSMutableString *ms = [NSMutableString string];
    
    NSScanner *scanner = [NSScanner scannerWithString:text];
    while (!scanner.isAtEnd) {
        
        NSString *s;
        if ([scanner scanUpToString:@"{\\" intoString:&s]) {
            
            [ms appendString:s];
        }
        
        if (!([scanner scanString:@"{\\" intoString:nil] &&
              [scanner scanUpToString:@"}" intoString:nil] &&
              [scanner scanString:@"}" intoString:nil])) {
            
            break;
        }
    }
    
    return ms;
}

@end

@implementation VideoFrameRGB
- (VideoFrameType) format { return VideoFrameTypeRGB; }
- (UIImage *) asImage
{
    UIImage *image = nil;
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(_rgb));
    if (provider) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace) {
            CGImageRef imageRef = CGImageCreate(self.width,
                                                self.height,
                                                8,
                                                24,
                                                self.linesize,
                                                colorSpace,
                                                kCGBitmapByteOrderDefault,
                                                provider,
                                                NULL,
                                                YES, // NO
                                                kCGRenderingIntentDefault);
            
            if (imageRef) {
                image = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
            }
            CGColorSpaceRelease(colorSpace);
        }
        CGDataProviderRelease(provider);
    }
    
    return image;
}
@end


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
    CGFloat             _videoTimeBase;//!<应该是一帧的时间单位
    NSInteger           _videoStream;//!<正在打开的v视频流
    NSArray             *_videoStreams;//!<v视频流所在文件中的位置，能打开的视频流
    CGFloat             _position;//解码视频帧的位置
    
    NSInteger           _audioStream;//!<正在打开的a音频流
    NSArray             *_audioStreams;//!<能打开的音频流
    NSArray             *_subtitleStreams;//!<文件流中所有字幕流中的位置
    
    NSUInteger          _subtitleStream;
    AVCodecContext      *_subtitleCodeCtx;
    NSInteger           _subtitleASSEvents;
    
    NSUInteger          _artworkStream;//!<v视频流中的插图流？，反正不是正在读的
    BOOL                _hasError;
    BOOL                _hasVideoError;
    BOOL                _hasAudioError;
    BOOL                _isEOF;
    
    NSMutableArray      *_videoFrames;
    CGFloat             _bufferedDuration;
    KxMovieGLView       *_glView;
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
    
    NSLog(@"%s",avcodec_configuration());
    
    _hasError = NO;
    NSString *path = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    
    //path = @"rtsp://admin:admin@192.168.100.1:554/cam1/h264";
    //path = [[NSBundle mainBundle]pathForResource:@"static" ofType:@"mov"];
    
    [self openFileWithPath:path];
    
    if([self openVideoStream] == CQMovieErrorNone){
        //如果打得了开视频就找字幕流
        _subtitleStreams = collectStreams(_formatCtx, AVMEDIA_TYPE_SUBTITLE);
        NSLog(@"%@",_subtitleStreams);
    }
    
}

-(CQMovieError)openSubTitleStream:(NSInteger)subtitleStream{
    
    AVCodecContext *codeCtx = _formatCtx->streams[subtitleStream]->codec;
    AVCodec *codec = avcodec_find_decoder(codeCtx->codec_id);
    if (!codec) {
        return CQMovieErrorCodecNotFount;
    }
    const AVCodecDescriptor *codecDesc = avcodec_descriptor_get(codeCtx->codec_id);
    if (codecDesc && (codecDesc->props & AV_CODEC_PROP_BITMAP_SUB)) {
        return CQMovieErrorStreamInfoNotFound;
    }
    if (avcodec_open2(codeCtx, codec, NULL)<0) {
        return CQMovieErrorOpenCodec;
    }
    _subtitleStream = subtitleStream;
    _subtitleCodeCtx = codeCtx;
    _subtitleASSEvents = -1;
    
    if (codeCtx->subtitle_header_size) {
        NSString *s = [[NSString alloc]initWithBytes:codeCtx->subtitle_header length:codeCtx->subtitle_header_size encoding:NSASCIIStringEncoding];
        if (s.length) {
            NSArray *fields = [KxMovieSubtitleASSParser parseEvents:s];
            if (fields.count && [fields.lastObject isEqualToString:@"Text"]) {
                _subtitleASSEvents = fields.count;
                NSLog(@"subtitle ass events: %@",[fields componentsJoinedByString:@","]);
            }
        }
    }
    return CQMovieErrorNone;
}

-(CQMovieError)openAudioStream{
    
    CQMovieError errorCode = CQMovieErrorStreamNotFount;
    _audioStreams = collectStreams(_formatCtx, AVMEDIA_TYPE_AUDIO);
    for (NSNumber *loc in _audioStreams) {
        const NSUInteger iStream = loc.integerValue;
        if (0==(_formatCtx->streams[iStream]->disposition & AV_DISPOSITION_ATTACHED_PIC)) {
            errorCode = [self openVideoStreamAt:iStream];
        }else{
            _artworkStream = iStream;
        }
    }
    
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
        NSLog(@"-----YUV");
    }else{
        _videoFrameType = VideoFrameTypeRGB;
        NSLog(@"-----RGB");
    }
    
    //在解码工作做完的时候创建播放view
    _glView = [[KxMovieGLView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 200) decoderIsYUV:YES FrameWidth:_videoCodecCtx->width FrameHeight:_videoCodecCtx->height];
    _glView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"%d  %d",_videoCodecCtx->width,_videoCodecCtx->height);
    _glView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_glView];
    
    
    [self tick];
    return CQMovieErrorNone;
}

-(void)tick{
    [self asyDecodeStream];
    CGFloat interval = [self presentFrame:nil];
    const NSTimeInterval time = MAX(interval + 0, 0.01);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self tick];
    });
}

-(void)asyDecodeStream{
    NSArray *frames = [self decodeVideoStream];
    _videoFrames = [NSMutableArray array];
    @synchronized(_videoFrames) {
        for (MovieFrame *frame in frames)
            if (frame.type == MovieFrameTypeVideo) {
                [_videoFrames addObject:frame];
                _bufferedDuration += frame.duration;
            }
    }
}

-(CGFloat)presentFrame:(NSArray *)arr{
    
    VideoFrame *frame;
    @synchronized(_videoFrames) {
        
        if (_videoFrames.count > 0) {
            
            
            frame = _videoFrames[0];
            [_videoFrames removeObjectAtIndex:0];
            _bufferedDuration -= frame.duration;
        }
    }
    
    if (frame) {
        return [self presetnVideoFrame:frame];
    }
    return 0;
}

-(CGFloat )presetnVideoFrame:(VideoFrame *)videoFrame{
    
    [_glView render:videoFrame];
    return videoFrame.duration;
}

//从视频流中解码出数据
-(NSArray *)decodeVideoStream{
    
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
                    //NSLog(@"getframe--");
                    VideoFrame *frame = [self handleVideoFrame];
                    if (frame) {
                        [result addObject:frame];
                        _position = frame.position;
                        decodedDuration += frame.duration;
                        if (decodedDuration > 0) {//这个0 是最小解码时间
                            finished = YES;
                        }
                    }
                }
                if (0 == len) {
                    break;
                }
                pktSize -= len;
            }
            
        }else if (packet.stream_index == _audioStream){
            //不管
        }else if (packet.stream_index == _artworkStream){
            
        }
        av_free_packet(&packet);
    }
    return result;
}

-(VideoFrame *)handleVideoFrame{
    if (!_videoFrame->data[0]) {
        return nil;
    }
    VideoFrame *frame;
    if (_videoFrameType == VideoFrameTypeYUV) {
            //YUV
        VideoFrameYUV *yuvFrame = [[VideoFrameYUV alloc]init];
        yuvFrame.luma = copyFrameData(_videoFrame->data[0], _videoFrame->linesize[0], _videoCodecCtx->width, _videoCodecCtx->height);
        yuvFrame.chromaB = copyFrameData(_videoFrame->data[1], _videoFrame->linesize[1], _videoCodecCtx->width/2, _videoCodecCtx->height/2);
        yuvFrame.chromaR = copyFrameData(_videoFrame->data[2], _videoFrame->linesize[2], _videoCodecCtx->width/2, _videoCodecCtx->height/2);
        frame = yuvFrame;
    }else{//RGB暂时不管
        
    }
    
    frame.width = _videoCodecCtx->width;
    frame.height = _videoCodecCtx->height;
    frame.position = av_frame_get_best_effort_timestamp(_videoFrame)*_videoTimeBase;
    const int64_t frameDuration = av_frame_get_pkt_duration(_videoFrame);
    if (frameDuration) {
        frame.duration = frameDuration * _videoTimeBase;
        frame.duration += _videoFrame->repeat_pict * _videoTimeBase * 0.5;
    }else{
        frame.duration = 1.0 / _fps;
    }
    //NSLog(@"VFD: %.4f %.4f | %lld ",frame.position,frame.duration,av_frame_get_pkt_pos(_videoFrame));
    return frame;//cq
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

static NSData * copyFrameData(UInt8 *src, int linesize, int width, int height)
{
    width = MIN(linesize, width);
    NSMutableData *md = [NSMutableData dataWithLength: width * height];
    Byte *dst = md.mutableBytes;
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dst, src, width);
        dst += width;
        src += linesize;
    }
    return md;
}

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
