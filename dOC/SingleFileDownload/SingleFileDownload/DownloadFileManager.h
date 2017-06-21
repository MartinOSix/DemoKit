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

+(instancetype)shareManager;
-(DownloadFileModel *)startDownloadWithURL:(NSString *)url Delegate:(id<NewDownloadFileDelegate>) delegate;

@end
