//
//  RunoAFHelper.h
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CQAFNetworkHelper,ResponseResult;
@interface RunoAFHelper : NSObject

+(CQAFNetworkHelper *)rnPostParameter:(NSDictionary *)dic Result:(void(^)(ResponseResult *))resultBlock;


@end
