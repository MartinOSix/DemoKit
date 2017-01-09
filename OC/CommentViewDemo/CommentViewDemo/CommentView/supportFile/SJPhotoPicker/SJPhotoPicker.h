//
//  SJPhotoPicker.h
//  SJPhotoPickerDemo
//
//  Created by Jaesun on 16/8/23.
//  Copyright © 2016年 S.J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CQAsset.h"
#import "SJPhotoPickerManager.h"

#define cqSelectFillNotification @"cqSelectFillNotification"
#define kImagesTotalCount 9

typedef void(^SJPhotoPickerBlock)(NSArray <PHAsset *> *assets);

@interface SJPhotoPicker : NSObject

@property (nonatomic, strong) SJPhotoPickerBlock photoPickerBlock;
@property (nonatomic, strong) NSArray<PHAsset *> *defaultPHAsset;
@property (nonatomic, assign) NSInteger selectedImageCount;

+ (instancetype)shareSJPhotoPicker;

- (void) showPhotoPickerToController:(UIViewController *)controller pickedAssets:(SJPhotoPickerBlock)photoPickerBlcok;

- (void) showPhotoPickerToController:(UIViewController *)controller defaultAssets:(NSArray<PHAsset *> *)defaultAssets pickedAssets:(SJPhotoPickerBlock)photoPickerBlcok;

@end
