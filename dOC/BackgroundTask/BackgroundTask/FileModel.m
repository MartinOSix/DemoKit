//
//  FileModel.m
//  BackgroundTask
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "FileModel.h"
#import <AFNetworking.h>

@interface FileModel ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** 流 */
@property (nonatomic, strong) NSOutputStream *stream;

@end

@implementation FileModel

- (NSURLSession *)backgroundSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //这个sessionConfiguration 很重要， com.zyprosoft.xxx  这里，这个com.company.这个一定要和 bundle identifier 里面的一致，否则ApplicationDelegate 不会调用handleEventsForBackgroundURLSession代理方法
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.zyprosoft.runo.backgroundsession"];
        //[NSURLSessionConfiguration backgroundSessionConfiguration:@"com.zyprosoft.runo.backgroundsession"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

-(NSFileHandle *)fileHandle{
    if (_fileHandle == nil) {
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        // 沙盒文件路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent];
        
        if (![manager fileExistsAtPath:path]) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [manager createFileAtPath:path contents:nil attributes:nil];
        }
        self.currentLength = [self fileLengthForPath:path];
        // 创建文件句柄
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    }
    return _fileHandle;
}

-(void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    [[NSUserDefaults standardUserDefaults] setFloat:progress forKey:self.downloadUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(instancetype)initWithUrl:(NSString *)url{
    
    if (self = [super init]) {
        
        NSAssert(url != nil, @"the url must be not nil");
        self.downloadUrl = url;
        self.currentLength = 0;
        self.fileLength = 0;
        if ([self downloadFileExists:self.downloadUrl.lastPathComponent]) {
            self.downloadType = DownloadType_success;
        }else if([self cacheFileExists:self.downloadUrl.lastPathComponent]){
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


-(BOOL)downloadFileExists:(NSString *)file{
    
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fileDir = [docDir stringByAppendingPathComponent:file];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:fileDir isDirectory:nil];
}

-(BOOL)cacheFileExists:(NSString *)file{
    
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fileDir = [cacheDir stringByAppendingPathComponent:file];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:fileDir isDirectory:nil];
}

-(void)startDownload{
    if (self.downloadType == DownloadType_success) {
        return;
    }
    if (self.downloadTask) {
        return;
    }
    //缓存路径
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *fileDir = [cacheDir stringByAppendingPathComponent:self.downloadUrl.lastPathComponent];
    NSString *identifier = [NSString stringWithFormat:@"com.runo.BackgroundTask.%@",self.downloadUrl.lastPathComponent];
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];

    NSURLSession *session = [self backgroundSession];//[NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:fileDir]) {
        // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
        [manager createFileAtPath:fileDir contents:nil attributes:nil];
    }
    self.currentLength = [self fileLengthForPath:fileDir];
    // 创建流
    self.stream = [NSOutputStream outputStreamToFileAtPath:fileDir append:YES];
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]];
    // 设置HTTP请求头中的Range
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",[self fileLengthForPath:fileDir]];
    [request setValue:range forHTTPHeaderField:@"Range"];
    // 创建一个Data任务
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
    self.downloadTask = task;
    self.downloadType = DownloadType_downloading;
    [self.delegate modelTypeChange:self];
    /*
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak typeof(self) weakSelf = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]];
    
    
    // 设置HTTP请求头中的Range
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",[self fileLengthForPath:fileDir]];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    self.downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"%@",error.userInfo);
            return;
        }
        
        // 清空长度
        weakSelf.currentLength = 0;
        weakSelf.fileLength = 0;
        
        // 关闭fileHandle
        [weakSelf.fileHandle closeFile];
        weakSelf.fileHandle = nil;
        
        NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent];
        NSString *fielPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent];
        
        
        if ([[NSFileManager defaultManager]moveItemAtPath:cachePath toPath:fielPath error:nil]) {
            NSLog(@"%@ downlaodSuccess",fielPath);
            weakSelf.downloadType = DownloadType_success;
            [weakSelf.delegate modelTypeChange:weakSelf];
        };
    }];
    
    [manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        NSLog(@"NSURLSessionResponseDisposition");
        
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        weakSelf.fileLength = response.expectedContentLength + self.currentLength;
        
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        //NSLog(@"setDataTaskDidReceiveDataBlock");
        
        @synchronized (weakSelf.fileHandle) {
            
            // 指定数据的写入位置 -- 文件内容的最后面
            [weakSelf.fileHandle seekToEndOfFile];
            
            // 向沙盒写入数据
            [weakSelf.fileHandle writeData:data];
            
            // 拼接文件总长度
            weakSelf.currentLength += data.length;
            
            // 获取主线程，不然无法正确显示进度。
            NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                // 下载进度
                if (weakSelf.fileLength == 0) {
                    [weakSelf.delegate getProgress:0.0];
                } else {
                    weakSelf.progress = (1.0 * weakSelf.currentLength / weakSelf.fileLength);
                    [weakSelf.delegate downloadProgress:weakSelf.currentLength TotoalByte:weakSelf.fileLength];
                    [weakSelf.delegate getProgress:(1.0 * weakSelf.currentLength / weakSelf.fileLength)];
                }
                
            }];
        }
    }];
    
    [self.downloadTask resume];
    self.downloadType = DownloadType_downloading;
    [self.delegate modelTypeChange:self];
    */
}

/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

-(void)stopOrContinueDownload{
    if (self.downloadType == DownloadType_downloading && self.downloadTask) {
        [self.downloadTask suspend];
        self.downloadType = DownloadType_StopDownload;
        [self.delegate modelTypeChange:self];
    }else if(self.downloadType == DownloadType_StopDownload){
        if (self.downloadTask == nil){
            [self startDownload];
        }else{
            [self.downloadTask resume];
            self.downloadType = DownloadType_downloading;
            [self.delegate modelTypeChange:self];
        }
    }else if(self.downloadType == DownloadType_unDownload){
        [self startDownload];
    }else if(self.downloadType == DownloadType_DownloadFaild){
        [self startDownload];
    }
}

#pragma mark NSURL_delegate



- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
    self.fileLength = response.expectedContentLength + self.currentLength;
    [self.stream open];
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
//-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    
    [self.stream write:data.bytes maxLength:data.length];
    // 拼接文件总长度
    self.currentLength += data.length;
    // 获取主线程，不然无法正确显示进度。
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
            // 下载进度
            if (self.fileLength == 0) {
                [self.delegate getProgress:0.0];
            } else {
                self.progress = (1.0 * self.currentLength / self.fileLength);
                [self.delegate downloadProgress:self.currentLength TotoalByte:self.fileLength];
                [self.delegate getProgress:(1.0 * self.currentLength / self.fileLength)];
            }
    }];

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    if (error != nil) {
        NSLog(@"%@",error.userInfo);
        
    }
    
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
    
    // 关闭fileHandle
    [self.stream close];
    self.stream = nil;
    self.downloadTask = nil;
    
    if (error == nil) {
        NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent];
        NSString *fielPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.downloadUrl.lastPathComponent];
        
        
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            if ([[NSFileManager defaultManager]moveItemAtPath:cachePath toPath:fielPath error:nil]) {
                NSLog(@"%@ downlaodSuccess",fielPath);
                self.downloadType = DownloadType_success;
                [self.delegate modelTypeChange:self];
            };
        }];

    }else{
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            self.downloadType = DownloadType_DownloadFaild;
            [self.delegate modelTypeChange:self];
        }];

    }
}


@end
