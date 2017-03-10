//
//  ADRecycleView.m
//  ADRecycleView
//
//  Created by runo on 17/3/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ADRecycleView.h"
#import "ADRecycleCollectionViewCell.h"
@interface ADRecycleView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,assign) NSInteger dataSourceCount;//!<比实际数量大2
@property(nonatomic,assign) NSInteger trueDataCount;//!<实际数据源数量
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation ADRecycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        self.collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[ADRecycleCollectionViewCell class] forCellWithReuseIdentifier:@"adCell"];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.delegate= self;
    }
    return self;
}


#pragma  mark - collectionViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"enddecelerating");
    if (self.dataSourceCount < 2) {
        return;
    }
    
    if (scrollView.contentOffset.x == 0) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceCount-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if (scrollView.contentOffset.x == (self.dataSourceCount-1) * self.collectionView.frame.size.width){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataSourceCount-2 &&
        (self.collectionView.contentOffset.x/self.collectionView.frame.size.width == self.dataSourceCount-1)) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.dataDelegate respondsToSelector:@selector(adRecycleViewADTotalCount)]) {
        
        self.trueDataCount = [self.dataDelegate adRecycleViewADTotalCount];
        if (self.trueDataCount < 2) {
            self.dataSourceCount = self.trueDataCount;
        }else{
            self.dataSourceCount = self.trueDataCount+2;
        }
    }else{
        self.dataSourceCount = 0;
    }
    
    [self setAnimate:_animate];
    
    return self.dataSourceCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ADRecycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adCell" forIndexPath:indexPath];
    
    
    if ([self.dataDelegate respondsToSelector:@selector(adRecycleViewLoadDataWithImageView:WithIndex:)]) {
        
        if (self.trueDataCount > 1) {
            
            NSInteger tureIndex = 0;
            if (indexPath.row == 0) {
                tureIndex = (self.dataSourceCount-2)-1;
            }else if (indexPath.row == self.dataSourceCount-1) {
                tureIndex = 0;
            }else{
                tureIndex = indexPath.row-1;
            }
            [self.dataDelegate adRecycleViewLoadDataWithImageView:cell.adImageView WithIndex:tureIndex];
        }else{
            [self.dataDelegate adRecycleViewLoadDataWithImageView:cell.adImageView WithIndex:indexPath.row];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataDelegate respondsToSelector:@selector(adRecycleViewDidSelectViewAtIndex:)]) {
        NSInteger tureIndex = indexPath.row;
        if (self.trueDataCount > 1) {
            if (indexPath.row == 0) {
                tureIndex = (self.dataSourceCount-2)-1;
            }else if (indexPath.row == self.dataSourceCount-1) {
                tureIndex = 0;
            }else{
                tureIndex = indexPath.row-1;
            }
        }
        [self.dataDelegate adRecycleViewDidSelectViewAtIndex:tureIndex];
    }
    
}


-(void)setAnimate:(BOOL)animate{
    _animate = animate;
    
    if (animate) {
        
        if (self.timer.isValid) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        if (self.trueDataCount > 1) {
            self.timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSInteger index = self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
                //0 1 2 3
                // 4
                
                if (index+1 < self.dataSourceCount) {
                    
                    [self.collectionView setContentOffset:CGPointMake((index+1)*self.collectionView.frame.size.width, 0) animated:YES];
                    
                }
            }];
            [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }else{
        if (self.timer.isValid) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

@end
