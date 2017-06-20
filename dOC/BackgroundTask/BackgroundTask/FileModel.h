//
//  FileModel.h
//  BackgroundTask
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonUtile.h"
@class FileModel;
@protocol DownloadFileDelegate <NSObject>

-(void)getProgress:(CGFloat)progress;
-(void)modelTypeChange:(FileModel *)model;
-(void)downloadProgress:(CGFloat)downloadByte TotoalByte:(CGFloat)totalByte;

@end


@interface FileModel : NSObject

/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;

@property(nonatomic,weak) id<DownloadFileDelegate> delegate;
@property(nonatomic,strong) NSString * downloadUrl;
@property(nonatomic,strong) NSString * downloadFile;
@property(nonatomic,assign) DownloadType downloadType;
@property (nonatomic, assign) CGFloat progress;

-(instancetype)initWithUrl:(NSString *)url;
-(void)startDownload;
-(void)stopOrContinueDownload;

@end
