//
//  SJPickPhotoController.h
//  SJPhotoPickerDemo
//
//  Created by Jaesun on 16/8/19.
//  Copyright © 2016年 S.J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "SJPhotoModel.h"

@interface SJPickPhotoController : UIViewController
/**
 *  所有照片
 */
@property (nonatomic, strong) NSMutableArray<SJPhotoModel *> *photoArray;
/**
 *  选择的照片
 */
@property (nonatomic, strong) NSMutableArray<SJPhotoModel *> *pickedArray;
@property (nonatomic, strong) PHFetchResult *assetResult;

@end
