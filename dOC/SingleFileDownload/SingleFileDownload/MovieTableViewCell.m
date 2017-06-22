//
//  MovieTableViewCell.m
//  BackgroundTask
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "CommonUtile.h"
#import "AppDelegate.h"

@interface MovieTableViewCell ()<NewDownloadFileDelegate>

@property(nonatomic,strong) DownloadFileModel *model;
@property (weak, nonatomic) IBOutlet UILabel *downloadInfoLabel;

@end

@implementation MovieTableViewCell

- (IBAction)actionBtnClick:(id)sender {
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate presentNotification:self.model.downloadUrl.lastPathComponent];
    if (self.model.cqDownloadType == DownloadType_downloading) {
        [self.model stopDonwloadTask];
    }else{
        [self.model startDownloadTask];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadModel:(DownloadFileModel *)model{
    
    self.model = model;
    self.titleLabel.text = self.model.cqDownloadUrl.lastPathComponent;
    self.model.cqDelegate = self;
    self.progressBar.progress = 0;
    if (model.cqDownloadType == DownloadType_success) {
        self.progressBar.progress = 1;
    }
    self.downloadInfoLabel.text = [NSString stringWithFormat:@"%.2fM / %.2fM",self.model.cqCurrentDownloadLength/(1024*1024.0),self.model.cqTotalLength/(1024*1024.0)];
    switch (model.cqDownloadType) {
        case DownloadType_downloading:
            [self.actionBtn setTitle:@"暂停" forState:UIControlStateNormal];
            break;
        case DownloadType_success:
            [self.actionBtn setTitle:@"完成" forState:UIControlStateNormal];
            break;
        case DownloadType_StopDownload:
            [self.actionBtn setTitle:@"继续" forState:UIControlStateNormal];
            self.progressBar.progress = self.model.cqProgress;
            break;
        case DownloadType_unDownload:
            [self.actionBtn setTitle:@"开始" forState:UIControlStateNormal];
            break;
        case DownloadType_DownloadFaild:
            [self.actionBtn setTitle:@"继续" forState:UIWindowLevelNormal];
            self.downloadInfoLabel.text = @"下载失败";
            break;
        default:
            break;
    }
}

-(void)getProgress:(CGFloat)progress{
    self.progressBar.progress = progress;
}

-(void)downloadProgress:(CGFloat)downloadByte TotoalByte:(CGFloat)totalByte{
    
    self.downloadInfoLabel.text = [NSString stringWithFormat:@"%.2fM / %.2fM",downloadByte/(1024*1024),totalByte/(1024*1024)];
}

-(void)downloadTaskModel:(DownloadFileModel *)taskModel StateChange:(DownloadType)type
{
    if(self.model != taskModel) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case DownloadType_downloading:
                [self.actionBtn setTitle:@"暂停" forState:UIControlStateNormal];
                break;
            case DownloadType_success:
                [self.actionBtn setTitle:@"完成" forState:UIControlStateNormal];
                self.progressBar.progress = 1;
                break;
            case DownloadType_StopDownload:
                [self.actionBtn setTitle:@"继续" forState:UIControlStateNormal];
                break;
            case DownloadType_unDownload:
                [self.actionBtn setTitle:@"开始" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    });
    
}

-(void)downloadTaskModel:(DownloadFileModel *)taskModel Progress:(CGFloat)progress
{
    
    if (self.model != taskModel) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBar.progress = progress;
        self.downloadInfoLabel.text = [NSString stringWithFormat:@"%.2fM / %.2fM",self.model.cqCurrentDownloadLength/(1024*1024.0),self.model.cqTotalLength/(1024*1024.0)];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
