//
//  CQAFHttpSessionManagerConfigurator.h
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface CQAFHttpSessionManagerConfigurator : NSObject

/** 30s timeout  ResponseSerializer JSON */
+(AFHTTPSessionManager *)cqNormalManager;



@end
