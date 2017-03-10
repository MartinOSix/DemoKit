//
//  ADRecycleView.h
//  ADRecycleView
//
//  Created by runo on 17/3/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADRecycleViewDelegate <NSObject>

/**实际数据个数，内部会多两个*/
-(NSInteger )adRecycleViewADTotalCount;
/*装载数据*/
-(void)adRecycleViewLoadDataWithImageView:(UIImageView *)adView WithIndex:(NSInteger )index;
/*点击事件*/
-(void)adRecycleViewDidSelectViewAtIndex:(NSInteger)index;

@end

@interface ADRecycleView : NSObject

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,weak) id<ADRecycleViewDelegate> dataDelegate;
@property(nonatomic,assign) BOOL animate;

@end
