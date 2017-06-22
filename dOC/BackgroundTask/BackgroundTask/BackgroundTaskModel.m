//
//  BackgroundTaskModel.m
//  BackgroundTask
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "BackgroundTaskModel.h"
#import "AppDelegate.h"

@interface BackgroundTaskModel ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
//所有的task
@property (nonatomic, strong) NSMutableDictionary *allTasks;
//所有的Model
@property (nonatomic, strong) NSMutableDictionary *sessionModels;

@end

@implementation BackgroundTaskModel

#pragma makr property

-(NSURLSession *)session{
    
    if (_session == nil) {
        NSString *identify = [NSString stringWithFormat:@"com.runo.BackgroundTask.%@",self.downloadUrl];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
        //[NSURLSessionConfiguration backgroundSessionConfiguration:@"com.zyprosoft.runo.backgroundsession"];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return _session;
}

- (NSURLSession *)backgroundSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //这个sessionConfiguration 很重要， com.zyprosoft.xxx  这里，这个com.company.这个一定要和 bundle identifier 里面的一致，否则ApplicationDelegate 不会调用handleEventsForBackgroundURLSession代理方法
        
        NSString *identify = [NSString stringWithFormat:@"com.zyprosoft.runo.%@",self.downloadUrl];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
        //[NSURLSessionConfiguration backgroundSessionConfiguration:@"com.zyprosoft.runo.backgroundsession"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

#pragma mark init
-(instancetype)initWithUrl:(NSString *)url{
    
    if (self = [super init]) {
        
        NSAssert(url != nil, @"the url must be not nil");
        self.downloadUrl = url;
        self.currentLength = 0;
        self.fileLength = 0;
        //self.session = [self backgroundSession];
        if ([CommonUtile fileExistAtPath:[[CommonUtile downloadFileDir] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent]]) {
            
            self.downloadType = DownloadType_success;
            
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
    NSLog(@"current url  %@",self.downloadUrl);
    NSURL *downloadURL = [NSURL URLWithString:self.downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [self.downloadTask setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
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
        [self.downloadTask suspend];
        self.downloadType = DownloadType_StopDownload;
        if (self.delegate) {
            [self.delegate downloadTask:self.downloadTask StateChange:DownloadType_StopDownload];
        }
        
    }else if(self.downloadType == DownloadType_StopDownload){
        [self.downloadTask resume];
        self.downloadType = DownloadType_downloading;
        if (self.delegate) {
            [self.delegate downloadTask:self.downloadTask StateChange:DownloadType_downloading];
        }
    }
}

#pragma mark - NSURLSessionDownloadDelegate
//下载完成后回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
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

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    NSLog(@"error -- %@",error.description);
    if (error != nil) {
        
    }
    
}

@end
