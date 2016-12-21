//
//  ViewController.m
//  MasonryTest
//
//  Created by runo on 16/11/18.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "ViewController_ScrollView.h"
#import "ViewController_MutableConstraint.h"
#import "ViewController_Center.h"
#import "Masonry.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tabView;

@end

@implementation ViewController{
    NSArray *_dataSource;
    NSArray *_dataSourceTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MasonryExample";
    self.tabView = ({
        UITableView *tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        tab.delegate = self;
        tab.dataSource = self;
        
        [self.view addSubview:tab];
        tab;
    });
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.top.mas_offset(0);
        
    }];
    
    _dataSource = @[[ViewController_ScrollView class],
                    [ViewController_MutableConstraint class],
                    [ViewController_Center class]];
    _dataSourceTitle = @[@"scrollView",
                         @"动态改变约束,比例约束",
                         @"居中显示"];
    
    
}


#pragma mark - TableViewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = _dataSourceTitle[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIViewController *vc = [[(Class)_dataSource[indexPath.row] alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
