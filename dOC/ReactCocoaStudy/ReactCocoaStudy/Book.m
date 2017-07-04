//
//  Book.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "Book.h"
static int i = 0;
@implementation Book



+ (Book *)bookWithDict:(NSDictionary *)dic{
    
    Book *book = [[Book alloc]init];
    book.name = dic[@"title"];
    return book;
}

@end
