//
//  MovieTableViewCell.h
//  BackgroundTask
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BackgroundTaskModel;
@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

-(void)loadModel:(BackgroundTaskModel *)model;

@end
