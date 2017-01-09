//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by runo on 16/9/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTFrameParserConfig.h"
#import "CTData.h"
/**格式解析*/
@interface CTFrameParser : NSObject

+(CTData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config;

@end
