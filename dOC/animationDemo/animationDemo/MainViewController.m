//
//  MainViewController.m
//  animationDemo
//
//  Created by runo on 17/1/9.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController2.h"



/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *titles;
@property(nonatomic,strong) NSMutableArray *viewControllers;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = ({
        UITableView *tableview = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:tableview];
        tableview;
    });
    
    self.titles = [NSMutableArray arrayWithArray:@[
                                               @"图片部分显示，3D翻转，放大，旋转，平移",
                                               @"视图嵌套3d翻转",
                                               @"view拼接立体图形，并通过手势移动",
                                               @"划线显示，手势跟踪",
                                               @"直接在layer上显示文字",
                                               @"用layer拼接的立方体",
                                               @"渐变动画",
                                               @"关键帧动画，动画合集",
                                               @"转场动画",
                                               @"阴影，表盘，锚点，layer代理",
                                               @"CADisplayLink,波浪线"
                                                   ]];
    self.viewControllers = [NSMutableArray arrayWithArray:@[
                                                   @"ViewController2",
                                                   @"ViewController3",
                                                   @"ViewController4",
                                                   @"ViewController5",
                                                   @"ViewController6",
                                                   @"ViewController7",
                                                   @"ViewController8",
                                                   @"ViewController9",
                                                   @"ViewController10",
                                                   @"ViewController",
                                                   @"WaveViewViewController"
                                                            ]];
    
}


#pragma mark - TableViewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = self.viewControllers[indexPath.row];
    Class class = NSClassFromString(str);
    UIViewController *vc = [[class alloc]init];
    vc.title = self.titles[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
