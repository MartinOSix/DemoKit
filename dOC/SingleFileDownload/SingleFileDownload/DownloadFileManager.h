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

#pragma mark - 用户接口
+(instancetype)shareManager;
-(void)setUpSession;
/**
 *  根据URL获取下载的模型
 */
-(DownloadFileModel *)getModelByUrl:(NSString *)url;
-(void)startDownloadWithURL:(NSString *)url;
-(void)stopTaskWithUrl:(NSString *)url;
-(void)cancelTaskWithURL:(NSString *)url;

@end
