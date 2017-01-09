//
//  CQAsset.h
//  CommentViewDemo
//
//  Created by runo on 16/10/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Photos/Photos.h>

@interface CQAsset : PHAsset

@property(nonatomic,strong)UIImage *cacheImage;//!<缓存图片
@property(nonatomic,strong) PHAsset *phAsset;

+(instancetype)initwithPHAsset:(PHAsset *)phAsset;

@end
