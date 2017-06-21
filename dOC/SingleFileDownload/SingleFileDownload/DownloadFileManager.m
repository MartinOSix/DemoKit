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
@property (nonatomic, copy) NSData *resumeData;

@end

@implementation DownloadFileManager


-(NSURLSession *)session{
    
    if (_session == nil) {
        NSString *identify = [NSString stringWithFormat:@"com.runo.BackgroundTask.%@",self.downloadUrl];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        [_session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
            
        }];
    }
    return _session;
}

-(instancetype)initWithUrl:(NSString *)url{
    
    if (self = [super init]) {
        
        NSAssert(url != nil, @"the url must be not nil");
        self.downloadUrl = url;
        self.currentLength = 0;
        self.fileLength = 0;
        [self session];
        //self.session = [self backgroundSession];
        if ([CommonUtile fileExistAtPath:[[CommonUtile downloadFileDir] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent]]) {
            
            //self.downloadType = DownloadType_success;
            self.downloadType = DownloadType_unDownload;
            
        }else if([CommonUtile fileExistAtPath:[[CommonUtile downloadCacheFileDir] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent]]){
            self.downloadType = DownloadType_StopDownload;
            if (self.downloadTask) {
                self.downloadType = DownloadType_downloading;
            }
            CGFloat progress = [[NSUserDefaults standardUserDefaults]floatForKey:self.downloadUrl];
            self.progress = progress;
        }else{
            self.downloadType = DownloadType_unDownload;
        }
    }
    return self;
}

-(void)startDownload{
    
    if (self.downloadTask) {
        return;
    }
    
    NSURL *downloadURL = [NSURL URLWithString:self.downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    if (self.resumeData) {
        NSLog(@"resume current url  %@",self.downloadUrl);
        self.downloadTask = [self.session downloadTaskWithCorrectResumeData:self.resumeData];
    }else{
        NSLog(@"start current url  %@",self.downloadUrl);
        self.downloadTask = [self.session downloadTaskWithRequest:request];
    }
    [self.downloadTask resume];
//    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
//    [self.downloadTask setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    self.downloadType = DownloadType_downloading;
    if (self.delegate) {
        [self.delegate downloadTask:self.downloadTask StateChange:DownloadType_downloading];
    }
}


-(void)stopOrContinueDownload{
    
    if (self.downloadType == DownloadType_success) {
        return;
    }
    if (self.downloadTask == nil) {
        [self startDownload];
        
    }else if(self.downloadType == DownloadType_downloading){
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            self.resumeData = resumeData;
            self.downloadType = DownloadType_StopDownload;
            if (self.delegate) {
                [self.delegate downloadTask:self.downloadTask StateChange:DownloadType_StopDownload];
            }
        }];
        self.downloadTask = nil;
    }else if(self.downloadType == DownloadType_StopDownload){
        
        [self startDownload];

    }
}

#pragma mark - NSURLSessionDownloadDelegate
//下载完成后回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    NSLog(@"didFinishDownloadingToURL");
    NSString *fileUrl = [[CommonUtile downloadFileDir] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent];
    if ([CommonUtile fileExistAtPath:fileUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:fileUrl error:nil];
    }
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:fileUrl] error:nil];
    self.downloadType = DownloadType_success;
    if (self.delegate) {
        [self.delegate downloadTask:self.downloadTask StateChange:DownloadType_success];
    }
}
//下载中的回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    self.currentLength = totalBytesWritten;
    self.fileLength = totalBytesExpectedToWrite;
    if (self.delegate) {
        [self.delegate downloadTask:self.downloadTask Progress:totalBytesWritten TotalData:totalBytesExpectedToWrite];
    }
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
    
    NSLog(@"error -- %@",error.description);
    if (error != nil) {
        
        NSDictionary *dic = error.userInfo;
        NSString *url = dic[NSErrorFailingURLStringKey];
        NSData *data = dic[NSURLSessionDownloadTaskResumeData];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(string);
        self.resumeData = data;
        return;
    }
}



@end
