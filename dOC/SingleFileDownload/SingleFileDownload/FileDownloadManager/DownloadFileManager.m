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

-(void)setCacheAchieveModels{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.downloadModels];
    NSString *filePath = [[CommonUtile downloadFileDir] stringByAppendingPathComponent:@"data"];
    [data writeToFile:filePath atomically:YES];
}

-(void)getAchieveModels{
    NSString *filePath = [[CommonUtile downloadFileDir] stringByAppendingPathComponent:@"data"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        self.downloadModels = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (DownloadFileModel *model in self.downloadModels.allValues) {
            if (model.cqDownloadType == DownloadType_downloading) {
                model.cqDownloadType = DownloadType_DownloadFaild;
            }
        }
        
    }
    if (self.downloadModels == nil) {
        self.downloadModels = [NSMutableDictionary dictionary];
    }
    
}

+(instancetype)shareManager{
    
    static DownloadFileManager *fileManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManger = [[DownloadFileManager alloc]init];
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
        [self getAchieveModels];
        NSString *identify = [NSString stringWithFormat:@"com.runo.BackgroundTask.session"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
        
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        //这里可以获取到程序挂掉之前的task,--没用到
        [_session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
            NSLog(@"tasks count %zd",tasks.count);
        }];
    }
}

-(DownloadFileModel *)getModelByUrl:(NSString *)url{
    
    //首先从本地列表找
    DownloadFileModel *model = [self.downloadModels objectForKey:url.md5String];
    if (model != nil) {
        return model;
    }
    //从缓存中找,这个会创建，并从内存中找出对应的date
    model = [[DownloadFileModel alloc]initWithUrl:url];
    if (model != nil && model.cqDownloadType != DownloadType_success) {
        [self.downloadModels setObject:model forKey:url.md5String];
        [self setCacheAchieveModels];
        return model;
    }
    return model;
}

#pragma mark - 内部方法
-(void)startDownloadWithURL:(NSString *)url{
    
    //内存task
    NSURLSessionDownloadTask *downloadTask = [self.downloadTasks objectForKey:url.md5String];
    if (downloadTask != nil) {
        [downloadTask cancel];
    }
    DownloadFileModel *model = [self.downloadModels objectForKey:url.md5String];
    if (model == nil) {
       model = [self getModelByUrl:url];
    }
    [model checkDownload];
    if (model != nil && model.cqDownloadType == DownloadType_success) {
        NSLog(@"%@ 已经下载成功",url);
        return;
    }
    if (model.cqResumeData) {
        
        downloadTask = [self.session downloadTaskWithCorrectResumeData:model.cqResumeData];
    }else{
        downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:model.cqDownloadUrl]];
    }
    model.cqSessionTaskId = @(downloadTask.taskIdentifier).stringValue;
    [self.downloadTasks setObject:downloadTask forKey:url.md5String];
    [downloadTask resume];
    model.cqDownloadType = DownloadType_downloading;
    [self setCacheAchieveModels];
    return;
}

-(void)stopTaskWithUrl:(NSString *)url{
    
    NSURLSessionDownloadTask *task = [self.downloadTasks objectForKey:url.md5String];
    if (task == nil) {
        return;
    }
    DownloadFileModel *model = [self.downloadModels objectForKey:url.md5String];
    if (model == nil) {
        return;
    }
    if (model.cqDownloadType == DownloadType_downloading) {
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            model.cqResumeData = resumeData;
            model.cqDownloadType = DownloadType_StopDownload;
        }];
    }
}

-(void)cancelTaskWithURL:(NSString *)url{
    
    NSURLSessionDownloadTask *task = [self.downloadTasks objectForKey:url.md5String];
    if (task == nil) {
        return;
    }
    DownloadFileModel *model = [self.downloadModels objectForKey:url.md5String];
    [task cancel];
    model.cqDownloadType = DownloadType_unDownload;
    [self.downloadTasks removeObjectForKey:url.md5String];
}

#pragma mark - NSURLSessionDownloadDelegate

- (DownloadFileModel *)getModelBySessionTaskId:(NSUInteger)taskId{
    
    for (DownloadFileModel *model in self.downloadModels.allValues) {
        if ([model.cqSessionTaskId isEqualToString:@(taskId).stringValue]) {
            return model;
        }
    }
    return nil;
}

//下载完成后回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    DownloadFileModel *fileModel = [self getModelBySessionTaskId:downloadTask.taskIdentifier];
    if (fileModel == nil) {
        return;
    }
    NSString *fileUrl = fileModel.cqDownloadFilePath;
    if ([CommonUtile fileExistAtPath:fileUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:fileUrl error:nil];
    }
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:fileUrl] error:nil];
    NSLog(@"-download-%@",fileUrl);
    fileModel.cqDownloadType = DownloadType_success;
}

//下载中的回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    DownloadFileModel *fileModel = [self getModelBySessionTaskId:downloadTask.taskIdentifier];
    if (fileModel == nil) {
        return;
    }
    NSLog(@"taskIdentifier %p  %zd",downloadTask,downloadTask.taskIdentifier);
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
    
    NSLog(@"didCompleteWithError--");
    DownloadFileModel *fileModel = [self getModelBySessionTaskId:task.taskIdentifier];
    if (fileModel == nil) {
        return;
    }
    if (error == nil) {
        
        [self.downloadTasks removeObjectForKey:fileModel.cqDownloadUrl.md5String];
        [self.downloadModels removeObjectForKey:fileModel.cqDownloadUrl.md5String];
        
    }else{
        
        NSDictionary *dic = error.userInfo;
        if (dic[NSURLSessionDownloadTaskResumeData] != nil && dic[NSErrorFailingURLStringKey] != nil) {
            
            NSLog(@"%@",dic[NSErrorFailingURLStringKey]);
            fileModel.cqResumeData = dic[NSURLSessionDownloadTaskResumeData];
            
        }
    }
    [self setCacheAchieveModels];
}

@end
