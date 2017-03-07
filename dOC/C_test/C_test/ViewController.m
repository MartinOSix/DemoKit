//
//  ViewController.m
//  C_test
//
//  Created by runo on 17/2/17.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "avformat.h"

#import "stdafx.h"
#import "noFilter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //开始准备输出
    const char * _outPutName;
    const char * _inPutName;
    NSString *inputName = @"http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    _outPutName = [[NSString stringWithFormat:@"%@/%@.mp4", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ,date] cStringUsingEncoding:NSASCIIStringEncoding];//Output file URL
    
    _inPutName = [inputName cStringUsingEncoding:NSASCIIStringEncoding];
    
    char const *arc[3];
    arc[1] = _inPutName;
    arc[2] = _outPutName;
    _tmain(3, arc);
    NSLog(NSHomeDirectory());
    
}

-(void)test02170501{
    char info[40000] = { 0 };
    
    av_register_all();
    
    AVCodec *c_temp = av_codec_next(NULL);
    
    while(c_temp!=NULL){
        if (c_temp->decode!=NULL){
            sprintf(info, "%s[Dec]", info);
        }
        else{
            sprintf(info, "%s[Enc]", info);
        }
        switch (c_temp->type){
            case AVMEDIA_TYPE_VIDEO:
                sprintf(info, "%s[Video]", info);
                break;
            case AVMEDIA_TYPE_AUDIO:
                sprintf(info, "%s[Audio]", info);
                break;
            default:
                sprintf(info, "%s[Other]", info);
                break;
        }
        sprintf(info, "%s%10s\n", info, c_temp->name);
        
        
        c_temp=c_temp->next;
    }
    //printf("%s", info);
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    NSLog(@"%@\n\n",info_ns);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
