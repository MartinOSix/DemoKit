//
//  CQJSONParser.h
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQJSONParser : NSObject

+(id)objFromJsonString:(NSString *)jsonString;
+(id)objFromJsonData:(NSData *)jsonData;
+(NSString *)objToJsonString:(id)obj;
@end
