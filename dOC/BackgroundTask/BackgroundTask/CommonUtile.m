//
//  CommonUtile.m
//  BackgroundTask
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "CommonUtile.h"

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
