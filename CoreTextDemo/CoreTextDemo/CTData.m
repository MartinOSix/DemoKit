//
//  CTData.m
//  CoreTextDemo
//
//  Created by runo on 16/9/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CTData.h"

@implementation CTData

-(void)setCtFrame:(CTFrameRef)ctFrame{
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

-(void)dealloc{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

@end









