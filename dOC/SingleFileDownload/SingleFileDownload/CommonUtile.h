//
//  CommonUtile.h
//  BackgroundTask
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSInteger, DownloadType) {
    DownloadType_success,
    DownloadType_downloading,
    DownloadType_unDownload,
    DownloadType_StopDownload,
    DownloadType_DownloadFaild
};

@protocol NewDownloadFileDelegate <NSObject>

-(void)downloadTask:(NSURLSessionTask *)task StateChange:(DownloadType)type;
-(void)downloadTask:(NSURLSessionTask *)task Progress:(NSInteger)currendData TotalData:(NSInteger)totalData;

@end


@interface CommonUtile : NSObject


@property(nonatomic,class,readonly) NSString *downloadFileDir;
@property(nonatomic,class,readonly) NSString *downloadCacheFileDir;

+(BOOL)fileExistAtPath:(NSString *)path;
+(BOOL)createFileAtPath:(NSString *)path;
+ (NSInteger)fileLengthForPath:(NSString *)path;
@end
