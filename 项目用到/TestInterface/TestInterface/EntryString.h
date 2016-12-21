//
//  EntryString.h
//  finacecompany
//
//  Created by runo on 16/8/9.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EntryString : NSObject

/**解密数据*/
+(NSString *)decodeCryptWithContent:(NSString*)content;
/**加密数据*/
+(NSString *)encodeCryptWithContent:(NSString*)content;
/**获取请求Token*/
+(NSString *)getToken;
/**获取请求时间戳*/
+(NSString *)getTimeStampWithToken:(NSString *)str;

@end
