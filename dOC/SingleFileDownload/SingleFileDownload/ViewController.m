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
#import "CCLogSystem.h"

@interface ViewController () <NewDownloadFileDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@property (nonatomic,strong) DownloadFileModel *fileModel;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
}
- (IBAction)btnclick:(id)sender {
    NSString *fileUrl = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
    if (self.fileModel.cqDownloadType == DownloadType_downloading) {
        [self.fileModel stopDonwloadTask];
    }else{
        self.fileModel = [[DownloadFileManager shareManager]getModelByUrl:fileUrl];
        self.fileModel.cqDelegate = self;
        [self.fileModel startDownloadTask];
    }
    
}
- (IBAction)logclick:(id)sender {
    [CCLogSystem activeDeveloperUI];
}

-(void)downloadTaskModel:(DownloadFileModel *)taskModel Progress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.progress = taskModel.cqCurrentDownloadLength/(taskModel.cqTotalLength*1.0);
        NSLog(@"task %p  %.2f",taskModel,taskModel.cqCurrentDownloadLength/(taskModel.cqTotalLength*1.0));
        self.downloadLabel.text = [NSString stringWithFormat:@"%.2fM / %.2fM",taskModel.cqCurrentDownloadLength/(1024*1024.0),taskModel.cqTotalLength/(1024*1024.0)];
    });
}

-(void)downloadTaskModel:(DownloadFileModel *)taskModel StateChange:(DownloadType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case DownloadType_downloading:
                [self.btn setTitle:@"暂停" forState:UIControlStateNormal];
                break;
            case DownloadType_success:
                [self.btn setTitle:@"完成" forState:UIControlStateNormal];
                self.progress.progress = 1;
                self.downloadLabel.text = @"下载完成";
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
    
    
}

@end
