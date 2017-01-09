//
//  ViewController10.m
//  animationDemo
//
//  Created by runo on 16/9/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController10.h"

@interface ViewController10 ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong) NSArray *images;

@end

@implementation ViewController10

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = @[
                    [UIImage imageNamed:@"1.png"],
                    [UIImage imageNamed:@"2.png"],
                    [UIImage imageNamed:@"3.png"],
                    [UIImage imageNamed:@"4.png"]
                    ];
    self.imageView.image = [self.images firstObject];
    
}
- (IBAction)btnclick:(id)sender {
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    [self.imageView.layer addAnimation:transition forKey:nil];
    UIImage *currentImage = self.imageView.image;
    NSUInteger index = [self.images indexOfObject:currentImage];
    index = (index + 1)%self.images.count;
    self.imageView.image = self.images[index];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
