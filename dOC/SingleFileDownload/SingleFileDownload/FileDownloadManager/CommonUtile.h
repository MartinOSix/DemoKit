//
//  CommonUtile.h
//  BackgroundTask
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DownloadFileModel;

#pragma mark - enume DownloadType
typedef NS_OPTIONS(NSInteger, DownloadType) {
    DownloadType_success,
    DownloadType_downloading,
    DownloadType_unDownload,
    DownloadType_StopDownload,
    DownloadType_DownloadFaild
};

#pragma mark - Category CorrectedResumeData
@interface NSURLSession (CorrectedResumeData)
- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;
@end

#pragma mark - protocol NewDownloadFileDelegate
@protocol NewDownloadFileDelegate <NSObject>

-(void)downloadTaskModel:(DownloadFileModel *)taskModel StateChange:(DownloadType)type;
-(void)downloadTaskModel:(DownloadFileModel *)taskModel Progress:(CGFloat)progress;

@end

#pragma mark - class CommonUtile
@interface CommonUtile : NSObject

@property(nonatomic,class,readonly) NSString *downloadFileDir;
@property(nonatomic,class,readonly) NSString *downloadCacheFileDir;

+(BOOL)fileExistAtPath:(NSString *)path;
+(BOOL)createFileAtPath:(NSString *)path;
+ (NSInteger)fileLengthForPath:(NSString *)path;

@end

#pragma mark - category (mdtstring)
@interface NSString (MD5)

@property (readonly) NSString *md5String;

@end




#pragma mark - class DownloadFileModel

typedef void(^DownloadProgressCB)(CGFloat progress);
typedef void(^DownloadStateChangeCB)(DownloadType type);

@interface DownloadFileModel : NSObject <NSCoding>

@property(nonatomic,strong) NSString *cqDownloadUrl;
@property(nonatomic,readonly) NSString *cqDownloadFilePath;
@property(nonatomic,strong) NSString *cqSessionTaskId;

@property(nonatomic,strong) NSData  *cqResumeData;
@property(nonatomic,assign) CGFloat cqProgress;
@property(nonatomic,assign) NSUInteger cqTotalLength;
@property(nonatomic,assign) NSUInteger cqCurrentDownloadLength;
@property(nonatomic,assign) DownloadType cqDownloadType;

-(instancetype)initWithUrl:(NSString *)url;
- (void)checkDownload;
//用户接口
@property(nonatomic,weak) id<NewDownloadFileDelegate> cqDelegate;
-(void)startDownloadTask;
-(void)stopDonwloadTask;
-(void)cancelDownloadTask;

@end
