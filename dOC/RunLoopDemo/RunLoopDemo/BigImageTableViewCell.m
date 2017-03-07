//
//  BigImageTableViewCell.m
//  RunLoopDemo
//
//  Created by runo on 17/2/24.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "BigImageTableViewCell.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface BigImageTableViewCell ()

@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UIImageView *imageView2;
@property(nonatomic,strong)UIImageView *imageView3;

@end

@implementation BigImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3-10, kScreenWidth/3)];
        self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3-10, kScreenWidth/3)];
        self.imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/3*2, 0, kScreenWidth/3-10, kScreenWidth/3)];
        
        [self.contentView addSubview:_imageView1];
        [self.contentView addSubview:_imageView2];
        [self.contentView addSubview:_imageView3];
        
    }
    return self;
}

-(void)loadImagePath:(NSString *)path{
    
    self.imageView1.image = [UIImage imageWithContentsOfFile:path];
    self.imageView2.image = [UIImage imageWithContentsOfFile:path];
    self.imageView3.image = [UIImage imageWithContentsOfFile:path];

}

-(void)loadImageName:(NSString *)name{
    self.imageView1.image = [UIImage imageNamed:name];
    self.imageView2.image = [UIImage imageNamed:name];
    self.imageView3.image = [UIImage imageNamed:name];
}

@end
