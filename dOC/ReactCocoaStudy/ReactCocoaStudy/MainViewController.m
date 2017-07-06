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

@property (strong, nonatomic) UITableView *tableView;

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

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
