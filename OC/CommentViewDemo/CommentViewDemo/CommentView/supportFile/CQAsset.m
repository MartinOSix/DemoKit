//
//  CQAsset.m
//  CommentViewDemo
//
//  Created by runo on 16/10/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQAsset.h"
#import "SJPhotoPickerManager.h"

@implementation CQAsset

+(instancetype)initwithPHAsset:(PHAsset *)phAsset{
    
    CQAsset *cqAsset = [[CQAsset alloc]init];
    cqAsset.phAsset = phAsset;
    return cqAsset;
}

@end
