//
//  ViewController.m
//  Tableview
//
//  Created by runo on 17/7/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIScrollView *contentView;

@property(nonatomic,strong) UIView *whiteBGView;
@property(nonatomic,strong) UIButton *departmentBtn;
@property(nonatomic,strong) UIButton *personBtn;

@property(nonatomic,strong) UITableView *departmentTableView;
@property(nonatomic,strong) UITableView *personTableView;
@property(nonatomic,strong) UIButton *saveBtn;

@property(nonatomic,strong) NSArray *departDataSource;
@property(nonatomic,strong) NSArray *personDataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.departDataSource = @[@"税号",@"单位地址",@"电话号码",@"开户银行",@"银行账号"];
    self.personDataSource = @[@"电话号码",@"邮箱"];
    
    self.contentView = [[UIScrollView alloc]initWithFrame:kScreenBounds];
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    
    self.whiteBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth, kScreenHeight)];
    self.whiteBGView.backgroundColor = [UIColor whiteColor];
    
    self.departmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.departmentBtn.frame = CGRectMake(20, 0, 70, 30);
    [self.departmentBtn setTitle:@"单位" forState:UIControlStateNormal];
    [self.departmentBtn addTarget:self action:@selector(departBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.departmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.personBtn.frame = CGRectMake(110, 0, 70, 30);
    [self.personBtn setTitle:@"个人" forState:UIControlStateNormal];
    [self.personBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.personBtn  addTarget:self action:@selector(personBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.whiteBGView addSubview:self.departmentBtn];
    [self.whiteBGView addSubview:self.personBtn];
    
    self.personTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.personTableView.scrollEnabled = NO;
    self.personTableView.delegate = self;
    self.personTableView.dataSource = self;
    
    self.departmentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.departmentTableView.scrollEnabled = NO;
    self.departmentTableView.dataSource = self;
    self.departmentTableView.delegate = self;
    
    [self.whiteBGView addSubview:self.personTableView];
    [self.whiteBGView addSubview:self.departmentTableView];
    [self.contentView addSubview:self.whiteBGView];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.backgroundColor = [UIColor blueColor];
    self.saveBtn.frame = CGRectMake(10, 0, kScreenWidth-20, 30);
    
    [self.contentView addSubview:self.saveBtn];
    [self.view addSubview:self.contentView];
    
    [self.departmentTableView reloadData];
    [self.personTableView reloadData];
    [self.departmentBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)personBtnClick{
    self.personTableView.hidden = NO;
    self.departmentTableView.hidden = YES;
    
    CGRect frame = self.whiteBGView.frame;
    CGRect tableViewFrame = self.personTableView.frame;
    tableViewFrame.size.height = self.personTableView.contentSize.height;
    frame.size.height = 50+self.personTableView.contentSize.height;
    
    self.personTableView.frame = tableViewFrame;
    self.whiteBGView.frame = frame;
    CGRect btnframe = self.saveBtn.frame;
    btnframe.origin.y = self.whiteBGView.frame.origin.y+self.whiteBGView.frame.size.height+30;
    self.saveBtn.frame = btnframe;
    
    //如果下面超过了界面这里在调整contentView的contesize
}

-(void)departBtnClick{
    
    self.personTableView.hidden = YES;
    self.departmentTableView.hidden = NO;
    
    CGRect frame = self.whiteBGView.frame;
    CGRect tableViewFrame = self.departmentTableView.frame;
    tableViewFrame.size.height = self.departmentTableView.contentSize.height;
    frame.size.height = 50+self.departmentTableView.contentSize.height;
    
    self.departmentTableView.frame = tableViewFrame;
    self.whiteBGView.frame = frame;
    
    CGRect btnframe = self.saveBtn.frame;
    btnframe.origin.y = self.whiteBGView.frame.origin.y+self.whiteBGView.frame.size.height+30;
    self.saveBtn.frame = btnframe;
    
    
    //如果下面超过了界面这里在调整contentView的contesize
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.departmentTableView) {
        return  self.departDataSource.count;
    }else{
        return self.personDataSource.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (tableView == self.departmentTableView) {
        cell.textLabel.text = self.departDataSource[indexPath.row];
    }else{
        cell.textLabel.text = self.personDataSource[indexPath.row];
    }
    return cell;
}


@end
