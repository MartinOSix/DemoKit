//
//  CQURL.h
//  financeCompany
//
//  Created by runo on 16/5/18.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class showInfo;
@class UIView;

#define ServerUrl @"http://27.221.58.46:8000/webapi/ajax/phoneapi.ashx"
//#define ServerUrl @"http://192.168.1.100:8030/webapi/ajax/phoneapi.ashx"
//@"http://27.221.58.41:8000/WebAPI/Ajax/phoneAPI.ashx"
//#define ServerUrl @"http://192.168.1.100:8050/WebApi/"
@interface CQURL : NSObject

+(NSString *)getPostURL;
+(NSString*)ToJson:(id)obj;
+(id)FromJson:(NSString*)jsonStr;
+(NSString*)FromJsonStr:(NSString*)jsonStr;
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

/*
+(showInfo*)showLoding:(NSString *)message TargetView:(UIView*)view;
+(void)hideLoading:(showInfo*)info;
 */
@end
