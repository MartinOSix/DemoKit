//
//  ViewController.m
//  SingleFileDownload
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "DownloadFileManager.h"
#import "CommonUtile.h"

@interface ViewController () <NewDownloadFileDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@property (nonatomic,strong) DownloadFileManager *fileManger;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *fileUrl = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
    self.fileManger = [[DownloadFileManager alloc]initWithUrl:fileUrl];
    self.fileManger.delegate = self;
    
}
- (IBAction)btnclick:(id)sender {
    
    [self.fileManger stopOrContinueDownload];
}

-(void)downloadTask:(NSURLSessionTask *)task StateChange:(DownloadType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case DownloadType_downloading:
                [self.btn setTitle:@"暂停" forState:UIControlStateNormal];
                break;
            case DownloadType_success:
                [self.btn setTitle:@"完成" forState:UIControlStateNormal];
                self.progress.progress = 1;
                break;
            case DownloadType_StopDownload:
                [self.btn setTitle:@"继续" forState:UIControlStateNormal];
                break;
            case DownloadType_unDownload:
                [self.btn setTitle:@"开始" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    });
    
}


-(void)downloadTask:(NSURLSessionTask *)task Progress:(NSInteger)currendData TotalData:(NSInteger)totalData{
    
    NSLog(@"task %p",task);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.progress = currendData/(totalData*1.0);
        self.downloadLabel.text = [NSString stringWithFormat:@"%.2fM / %.2fM",currendData/(1024*1024.0),totalData/(1024*1024.0)];
    });
}

@end
