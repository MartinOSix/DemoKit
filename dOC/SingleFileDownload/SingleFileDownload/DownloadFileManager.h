//
//  DownloadFileManager.h
//  SingleFileDownload
//
//  Created by runo on 17/6/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonUtile.h"
@interface DownloadFileManager : NSObject

@property(nonatomic,weak) id<NewDownloadFileDelegate> delegate;

/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
@property(nonatomic,strong) NSString * downloadUrl;
@property(nonatomic,strong) NSString * downloadFile;
@property(nonatomic,assign) DownloadType downloadType;
@property (nonatomic, assign) CGFloat progress;
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

-(instancetype)initWithUrl:(NSString *)url;
-(void)startDownload;
-(void)stopOrContinueDownload;


@end
