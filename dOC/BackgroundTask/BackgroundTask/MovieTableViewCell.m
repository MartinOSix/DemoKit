//
//  MovieTableViewCell.m
//  BackgroundTask
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "FileModel.h"
#import "BackgroundTaskModel.h"
#import "AppDelegate.h"

@interface MovieTableViewCell ()<NewDownloadFileDelegate>

@property(nonatomic,strong) BackgroundTaskModel *model;
@property (weak, nonatomic) IBOutlet UILabel *downloadInfoLabel;

@end

@implementation MovieTableViewCell

- (IBAction)actionBtnClick:(id)sender {
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate presentNotification:self.model.downloadUrl.lastPathComponent];
    [self.model stopOrContinueDownload];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadModel:(BackgroundTaskModel *)model{
    
    self.model = model;
    self.titleLabel.text = self.model.downloadUrl.lastPathComponent;
    self.model.delegate = self;
    self.progressBar.progress = 0;
    if (model.downloadType == DownloadType_success) {
        self.progressBar.progress = 1;
    }
    self.downloadInfoLabel.text = [NSString stringWithFormat:@"%.2fM / %.2fM",self.model.currentLength/(1024*1024.0),self.model.fileLength/(1024*1024.0)];
    switch (model.downloadType) {
        case DownloadType_downloading:
            [self.actionBtn setTitle:@"暂停" forState:UIControlStateNormal];
            break;
        case DownloadType_success:
            [self.actionBtn setTitle:@"完成" forState:UIControlStateNormal];
            break;
        case DownloadType_StopDownload:
            [self.actionBtn setTitle:@"继续" forState:UIControlStateNormal];
            self.progressBar.progress = self.model.progress;
            break;
        case DownloadType_unDownload:
            [self.actionBtn setTitle:@"开始" forState:UIControlStateNormal];
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

-(void)downloadTask:(NSURLSessionTask *)task StateChange:(DownloadType)type{
    
    if (self.model.downloadTask != task) {
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


-(void)downloadTask:(NSURLSessionTask *)task Progress:(NSInteger)currendData TotalData:(NSInteger)totalData{
    
    if (self.model.downloadTask != task) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBar.progress = currendData/(totalData*1.0);
        self.downloadInfoLabel.text = [NSString stringWithFormat:@"%.2fM / %.2fM",currendData/(1024*1024.0),totalData/(1024*1024.0)];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
