//
//  CommentView.m
//  CommentViewDemo
//
//  Created by runo on 16/10/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CommentView.h"
#import "UITextView+CQAdd.h"
#import "SJPhotoPicker.h"

#define kcqScreen [UIScreen mainScreen].bounds
#define kcqScreenWidth kcqScreen.size.width
#define kcqScreenHeigth kcqScreen.size.height

#define ktextViewHeight 100
#define kImageCount 4 //一行几张图

//图像控件
@class CQImageView;
@protocol CQImageViewDelegate <NSObject>

-(void)cqImageViewDelegateBtnClick:(CQImageView *)cqImageView;

@end

@interface CQImageView : UIView

@property(nonatomic,weak) id<CQImageViewDelegate> delegate;//!<删除按钮回调
@property(nonatomic,strong)UIImageView *imageView;//!<图像View
@property(nonatomic,strong)UIButton *deleteBtn;//!<删除按钮

@end

//主控件（包括评论和图片选择）
@interface CommentView ()<CQImageViewDelegate>

@property(nonatomic,strong) UITextView *commentTV;//!<评论区
@property(nonatomic,strong) NSMutableArray<CQImageView *> *imageViews;//!<图片View数组
@property(nonatomic,strong) UIButton *addImageBtn;//!<添加按钮
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CommentView

-(NSString *)commentString{
    return self.commentTV.text;
}

-(NSMutableArray<CQImageView *> *)imageViews{
    if (_imageViews == nil) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectImages = [NSMutableArray array];
        self.commentTV = ({
            UITextView *field = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, kcqScreenWidth-20, ktextViewHeight)];
            [self addSubview:field];
            field;
        });
        self.addImageBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, CGRectGetMaxY(_commentTV.frame)+10, (kcqScreenWidth-40)/kImageCount, (kcqScreenWidth-40)/kImageCount);
            [btn addTarget:self action:@selector(choiseImageBtn) forControlEvents:UIControlEventTouchUpInside];
            //设置外观
            {
                btn.layer.borderColor = [UIColor blackColor].CGColor;
                btn.layer.borderWidth = 1;
                [btn setTitle:@"+" forState:UIControlStateNormal];
            }
            [self addSubview:btn];
            btn;
        });
        frame.size.height = CGRectGetMaxY(_addImageBtn.frame);
        self.frame = frame;
        if ([self.delegate respondsToSelector:@selector(commentViewAutoAdjustFrame:)]) {
            [self.delegate commentViewAutoAdjustFrame:self];
        }

    }
    return self;
}

-(void)choiseImageBtn{
    
    [[SJPhotoPicker shareSJPhotoPicker] showPhotoPickerToController:[CommentView cqGetController:self] defaultAssets:[self defaultAsset] pickedAssets:^(NSArray<PHAsset *> *assets) {
        self.dataArray = [NSMutableArray array];
        for (PHAsset *asset in assets) {
            CQAsset *cqasset = [CQAsset initwithPHAsset:asset];
            [self.dataArray addObject:cqasset];
        }
        [self reloadImages];
    }];
}

-(NSArray *)defaultAsset{
    NSMutableArray *marr = [NSMutableArray array];
    for (CQAsset *cqasset in self.dataArray) {
        [marr addObject:cqasset.phAsset];
    }
    return marr;
}

-(void)cqImageViewDelegateBtnClick:(CQImageView *)cqImageView{
    
    NSUInteger index = [self.imageViews indexOfObject:cqImageView];
    [self.dataArray removeObjectAtIndex:index];
    [self reloadImages];
}

-(void)reloadImages{
    
    [_selectImages removeAllObjects];
    [self.imageViews enumerateObjectsUsingBlock:^(CQImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.imageViews removeAllObjects];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        CQImageView *imageV = [[CQImageView alloc]initWithFrame:CGRectMake(10 + (i%kImageCount)*((kcqScreenWidth-40)/kImageCount+10), ktextViewHeight+10+(i/kImageCount)*((kcqScreenWidth-40)/kImageCount+10), (kcqScreenWidth-40)/kImageCount, (kcqScreenWidth-40)/kImageCount)];
        
        
        CQAsset *asset = self.dataArray[i];
        if (asset.cacheImage == nil) {
            
            [[SJPhotoPickerManager shareSJPhotoPickerManager] requestImageForPHAsset:asset.phAsset targetSize:PHImageManagerMaximumSize imageResult:^(UIImage *image) {
                imageV.imageView.image = image;
                [_selectImages addObject:image];
                asset.cacheImage = image;
            }];

        }else{
            
            imageV.imageView.image = asset.cacheImage;
            [_selectImages addObject:asset.cacheImage];
        }

        imageV.delegate = self;
        [self addSubview:imageV];
        [self.imageViews addObject:imageV];
    }
    if (self.dataArray.count < 9) {
        self.addImageBtn.hidden = NO;
        NSUInteger i = self.dataArray.count;
        CGRect frame = self.addImageBtn.frame;
        frame.origin = CGPointMake(10+(i%kImageCount)*((kcqScreenWidth-40)/kImageCount+10), ktextViewHeight+10+(i/kImageCount)*((kcqScreenWidth-40)/kImageCount+10));
        self.addImageBtn.frame = frame;
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_addImageBtn.frame);
        self.frame = frame;
    }else{
        self.addImageBtn.hidden = YES;
        CGRect frame = self.frame;
        frame.size.height = CGRectGetMaxY([self.imageViews lastObject].frame );
        self.frame = frame;
    }
    if ([self.delegate respondsToSelector:@selector(commentViewAutoAdjustFrame:)]) {
        [self.delegate commentViewAutoAdjustFrame:self];
    }
}

+(UIViewController *)cqGetController:(UIView *)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end

@implementation CQImageView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = ({
            UIImageView *image = [[UIImageView alloc]initWithFrame:self.bounds];
            [self addSubview:image];
            image;
        });
        self.deleteBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor redColor];//在这里换删除的图片
            [btn setTitle:@"X" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.frame = CGRectMake(frame.size.width-20, 0, 20, 20);
            [btn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}

//回调删除事件
-(void)deleteBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(cqImageViewDelegateBtnClick:)]) {
        [self.delegate cqImageViewDelegateBtnClick:self];
    }
}

@end
