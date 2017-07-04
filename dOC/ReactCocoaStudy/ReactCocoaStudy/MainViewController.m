//
//  MainViewController.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "MainViewController.h"
#import "RequestViewModel.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) RequestViewModel *requesViewModel;

@end

@implementation MainViewController

- (RequestViewModel *)requesViewModel
{
    if (_requesViewModel == nil) {
        _requesViewModel = [[RequestViewModel alloc] init];
    }
    return _requesViewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self.requesViewModel;
    RACSignal *requesSignal = [self.requesViewModel.requesCommand execute:nil];
    [requesSignal subscribeNext:^(NSArray *x) {
        self.requesViewModel.models = x;
        [self.tableView reloadData];
    }];
}


@end
