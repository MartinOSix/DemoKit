//
//  CommonUtile.m
//  BackgroundTask
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "CommonUtile.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#pragma mark - C Function

static NSData * correctRequestData(NSData *data);
static NSMutableDictionary *getResumeDictionary(NSData *data);

static NSData *correctResumeData(NSData *data) {
    NSString *kResumeCurrentRequest = @"NSURLSessionResumeCurrentRequest";
    NSString *kResumeOriginalRequest = @"NSURLSessionResumeOriginalRequest";
    if (data == nil) {
        return  nil;
    }
    NSMutableDictionary *resumeDictionary = getResumeDictionary(data);
    if (resumeDictionary == nil) {
        return nil;
    }
    resumeDictionary[kResumeCurrentRequest] = correctRequestData(resumeDictionary[kResumeCurrentRequest]);
    resumeDictionary[kResumeOriginalRequest] = correctRequestData(resumeDictionary[kResumeOriginalRequest]);
    NSData *result = [NSPropertyListSerialization dataWithPropertyList:resumeDictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    return result;
}

static NSData * correctRequestData(NSData *data) {
    if (!data) {
        return nil;
    }
    // return the same data if it's correct
    if ([NSKeyedUnarchiver unarchiveObjectWithData:data] != nil) {
        return data;
    }
    NSMutableDictionary *archive = [[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:nil] mutableCopy];
    
    if (!archive) {
        return nil;
    }
    NSInteger k = 0;
    id objectss = archive[@"$objects"];
    while ([objectss[1] objectForKey:[NSString stringWithFormat:@"$%ld",k]] != nil) {
        k += 1;
    }
    NSInteger i = 0;
    while ([archive[@"$objects"][1] objectForKey:[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%ld",i]] != nil) {
        NSMutableArray *arr = archive[@"$objects"];
        NSMutableDictionary *dic = arr[1];
        id obj = [dic objectForKey:[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%ld",i]];
        if (obj) {
            [dic setValue:obj forKey:[NSString stringWithFormat:@"$%ld",i+k]];
            [dic removeObjectForKey:[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%ld",i]];
            [arr replaceObjectAtIndex:1 withObject:dic];
            archive[@"$objects"] = arr;
        }
        i++;
    }
    if ([archive[@"$objects"][1] objectForKey:@"__nsurlrequest_proto_props"] != nil) {
        NSMutableArray *arr = archive[@"$objects"];
        NSMutableDictionary *dic = arr[1];
        id obj = [dic objectForKey:@"__nsurlrequest_proto_props"];
        if (obj) {
            [dic setValue:obj forKey:[NSString stringWithFormat:@"$%ld",i+k]];
            [dic removeObjectForKey:@"__nsurlrequest_proto_props"];
            [arr replaceObjectAtIndex:1 withObject:dic];
            archive[@"$objects"] = arr;
        }
    }
    // Rectify weird "NSKeyedArchiveRootObjectKey" top key to NSKeyedArchiveRootObjectKey = "root"
    if ([archive[@"$top"] objectForKey:@"NSKeyedArchiveRootObjectKey"] != nil) {
        [archive[@"$top"] setObject:archive[@"$top"][@"NSKeyedArchiveRootObjectKey"] forKey: NSKeyedArchiveRootObjectKey];
        [archive[@"$top"] removeObjectForKey:@"NSKeyedArchiveRootObjectKey"];
    }
    // Reencode archived object
    NSData *result = [NSPropertyListSerialization dataWithPropertyList:archive format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
    return result;
}

static NSMutableDictionary *getResumeDictionary(NSData *data) {
    NSMutableDictionary *iresumeDictionary = nil;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0) {
        id root = nil;
        id  keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        @try {
            root = [keyedUnarchiver decodeTopLevelObjectForKey:@"NSKeyedArchiveRootObjectKey" error:nil];
            if (root == nil) {
                root = [keyedUnarchiver decodeTopLevelObjectForKey:NSKeyedArchiveRootObjectKey error:nil];
            }
        } @catch(NSException *exception) {
            
        }
        [keyedUnarchiver finishDecoding];
        iresumeDictionary = [root mutableCopy];
    }
    
    if (iresumeDictionary == nil) {
        iresumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
    }
    return iresumeDictionary;
}

#pragma mark - Category CorrectedResumeData

@implementation NSURLSession (CorrectedResumeData)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData {
    NSString *kResumeCurrentRequest = @"NSURLSessionResumeCurrentRequest";
    NSString *kResumeOriginalRequest = @"NSURLSessionResumeOriginalRequest";
    
    NSData *cData = correctResumeData(resumeData);
    cData = cData ? cData:resumeData;
    NSURLSessionDownloadTask *task = [self downloadTaskWithResumeData:cData];
    NSMutableDictionary *resumeDic = getResumeDictionary(cData);
    if (resumeDic) {
        if (task.originalRequest == nil) {
            NSData *originalReqData = resumeDic[kResumeOriginalRequest];
            NSURLRequest *originalRequest = [NSKeyedUnarchiver unarchiveObjectWithData:originalReqData ];
            if (originalRequest) {
                [task setValue:originalRequest forKey:@"originalRequest"];
            }
        }
        if (task.currentRequest == nil) {
            NSData *currentReqData = resumeDic[kResumeCurrentRequest];
            NSURLRequest *currentRequest = [NSKeyedUnarchiver unarchiveObjectWithData:currentReqData];
            if (currentRequest) {
                [task setValue:currentRequest forKey:@"currentRequest"];
            }
        }
    }
    return task;
}

@end

#pragma mark - class CommonUtile
@implementation CommonUtile


+(NSString *)downloadFileDir{
    
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    return docDir;
}

+(NSString *)downloadCacheFileDir{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    return cacheDir;
}

+(BOOL)fileExistAtPath:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil];
}

+(BOOL)createFileAtPath:(NSString *)path{
   return [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
}

/**
 * 获取已下载的文件大小
 */
+ (NSInteger)fileLengthForPath:(NSString *)path {
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

@end
#pragma mark - Category NSStringMD5
@implementation NSString (MD5)

- (NSString *)md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

@end

#pragma mark - DownloadModel

@implementation DownloadFileModel

-(instancetype)initWithUrl:(NSString *)url{
    
    NSAssert(url != nil, @"the url can't be nil");
    if(self = [super init]){
        
        self.cqCurrentDownloadLength = 0;
        self.cqTotalLength = 0;
        self.cqDownloadUrl = url;
        self.cqDownloadType = DownloadType_unDownload;
        [self loadCacheFile];
        self.cqDownloadFilePath = [[[CommonUtile downloadFileDir] stringByAppendingString:self.cqDownloadUrl.md5String]stringByAppendingPathExtension:self.cqDownloadUrl.pathExtension];
        [self checkDownload];
        
    }
    return self;
    
}

- (void)loadCacheFile{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:self.cqDownloadUrl.md5String];
    if (dic == nil) {
        
        return;
    }
    if (dic[@"resumeData"] != [NSNull null]) {
        self.cqResumeData = dic[@"resumeData"];
        self.cqDownloadType = DownloadType_StopDownload;
    }
    self.cqCurrentDownloadLength = [dic[@"currentLength"] unsignedIntegerValue];
    self.cqTotalLength = [dic[@"totalLength"] unsignedIntegerValue];
}

- (void)setCacheFile{
    
    NSMutableDictionary *cacheDic = [NSMutableDictionary dictionary];
    if (self.cqResumeData == nil) {
        
        [cacheDic setObject:[NSNull null] forKey:@"resumeData"];
    }
    [cacheDic setObject:@(self.cqCurrentDownloadLength) forKey:@"currentLength"];
    [cacheDic setObject:@(self.cqTotalLength) forKey:@"totalLength"];
    [[NSUserDefaults standardUserDefaults] setObject:cacheDic forKey:self.cqDownloadUrl.md5String];
    
}

- (void)removeCacheFile{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.cqDownloadUrl.md5String];
}

- (void)checkDownload{
    
    if([[NSFileManager defaultManager] fileExistsAtPath:self.cqDownloadFilePath]){
        self.cqDownloadType = DownloadType_success;
    }
}

- (void)setCqDownloadType:(DownloadType)cqDownloadType{
    _cqDownloadType = cqDownloadType;
    if ([self.cqDelegate respondsToSelector:@selector(downloadTaskModel:StateChange:)]) {
        [self.cqDelegate downloadTaskModel:self StateChange:cqDownloadType];
    }
}

- (void)setCqProgress:(CGFloat)cqProgress{
    _cqProgress = cqProgress;
    if ([self.cqDelegate respondsToSelector:@selector(downloadTaskModel:Progress:)]) {
        [self.cqDelegate downloadTaskModel:self Progress:cqProgress];
    }
}

@end
