//
//  ViewController_A.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController_A.h"

@interface ViewController_A ()

@end

@implementation ViewController_A

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}





- (IBAction)btnclick:(id)sender {
    
    if (self.delegateSingnal) {
        [self.delegateSingnal sendNext:nil];
    }
}



@end
