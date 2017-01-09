//
//  ViewController3.m
//  animationDemo
//
//  Created by runo on 16/9/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController3.h"

@interface ViewController3 ()
@property (weak, nonatomic) IBOutlet UIView *outview;
@property (weak, nonatomic) IBOutlet UIView *innerview;

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CATransform3D outer = CATransform3DIdentity;
    outer.m34 = -1.0/500.0;
    outer = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
    self.outview.layer.transform = outer;
    
    CATransform3D inner = CATransform3DIdentity;
    inner.m34 = -1.0/500.0;
    inner = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);
    self.innerview.layer.transform = inner;
    
}

-(void)test1{
    CATransform3D outer = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    self.outview.layer.transform = outer;
    
    CATransform3D inner = CATransform3DMakeRotation(-M_PI_4, 0, 0, 1);
    self.innerview.layer.transform = inner;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
