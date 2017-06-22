//
//  HomeViewController.m
//  BackgroundTask
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "HomeViewController.h"
#import "MovieTableViewCell.h"
#import "DownloadFileManager.h"
#import "CommonUtile.h"
#import "CCLogSystem.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    for (int i = 1; i < 11; i ++) {
        NSString *url = [NSString stringWithFormat:@"http://120.25.226.186:32812/resources/videos/minion_%02d.mp4",i];
        DownloadFileModel *model = [[DownloadFileManager shareManager]getModelByUrl:url];
        [self.dataSource addObject:model];
    }
    DownloadFileModel *model = [[DownloadFileManager shareManager]getModelByUrl:@"http://get.videolan.org/vlc/2.2.5.1/macosx/vlc-2.2.5.1.dmg"];
    [self.dataSource addObject:model];
    
    self.tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell loadModel:self.dataSource[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CCLogSystem activeDeveloperUI];
}

@end
