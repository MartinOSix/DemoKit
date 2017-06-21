//
//  DownloadFileManager.m
//  SingleFileDownload
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "DownloadFileManager.h"
#import "AppDelegate.h"

@interface DownloadFileManager ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *downloadTasks;
@property (nonatomic, strong) NSMutableDictionary *downloadModels;

@end

@implementation DownloadFileManager

+(instancetype)shareManager{
    
    static DownloadFileManager *fileManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        fileManger = [[DownloadFileManager alloc]init];
        fileManger.downloadModels = [NSMutableDictionary dictionary];
        fileManger.downloadTasks = [NSMutableDictionary dictionary];
    });
    return fileManger;
}

-(NSURLSession *)session{
    
    if (_session == nil) {
        
        [self setUpSession];
    }
    return _session;
}

-(void)setUpSession{
    
    if (_session == nil) {
        
        NSString *identify = [NSString stringWithFormat:@"com.runo.BackgroundTask.session"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
        
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        //这里可以获取到程序挂掉之前的task
        [_session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
            
        }];
    }
    
}



-(DownloadFileModel *)startDownloadWithURL:(NSString *)url Delegate:(id<NewDownloadFileDelegate>) delegate{
    
    DownloadFileModel *model = [self.downloadModels objectForKey:url.md5String];
    model.cqDelegate = delegate;
    if (model == nil) {
        model = [[DownloadFileModel alloc]initWithUrl:url];
    }
    if (model.cqDownloadType == DownloadType_success) {
        return model;
    }
    NSURLSessionDownloadTask *downloadTask = nil;
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    if (model.cqResumeData != nil) {
        downloadTask = [self.session downloadTaskWithCorrectResumeData:model.cqResumeData];
        
        [downloadTask setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    }else{
        downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:model.cqDownloadUrl]];
        [downloadTask setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    }
    [self.downloadTasks setObject:downloadTask forKey:model.cqDownloadUrl.md5String];
    [self.downloadModels setObject:model forKey:@(taskIdentifier).stringValue];
    [downloadTask resume];
    model.cqDownloadType = DownloadType_downloading;
    return model;
}

#pragma mark - NSURLSessionDownloadDelegate
//下载完成后回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    
    DownloadFileModel *fileModel = [self.downloadModels objectForKey:@(downloadTask.taskIdentifier).stringValue];
    NSString *fileUrl = fileModel.cqDownloadFilePath;
    if ([CommonUtile fileExistAtPath:fileUrl]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:fileUrl error:nil];
    }
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:fileUrl] error:nil];
    fileModel.cqDownloadType = DownloadType_success;
    
}

//下载中的回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    DownloadFileModel *fileModel = [self.downloadModels objectForKey:@(downloadTask.taskIdentifier).stringValue];
    fileModel.cqCurrentDownloadLength = totalBytesWritten;
    fileModel.cqTotalLength = totalBytesExpectedToWrite;
    fileModel.cqProgress = 1.0*totalBytesWritten/totalBytesExpectedToWrite;
}

//
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSLog(@"didResumeAtOffset");
}



#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    NSLog(@"所有任务已完成!");
}

//所有任务结束都会走这里，即使后台结束，当创建了一个相同的indentify的session时，之前的task代理也会走这里，cancelbyresumeData也走这里，正常结束也走这里，总之一个task的结束一定会走这里
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    DownloadFileModel *fileModel = [self.downloadModels objectForKey:@(task.taskIdentifier).stringValue];
    
    if (error == nil) {
        
        [self.downloadTasks removeObjectForKey:fileModel.cqDownloadUrl.md5String];
        [self.downloadModels removeObjectForKey:@(task.taskIdentifier).stringValue];
    }else{
        
        NSDictionary *dic = error.userInfo;
        if (dic[NSURLSessionDownloadTaskResumeData] != nil) {
            fileModel.cqResumeData = dic[NSURLSessionDownloadTaskResumeData];
        }
        [fileModel setCacheFile];
    }
}

@end
