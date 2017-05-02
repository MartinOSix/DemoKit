//
//  ViewController.m
//  openURL
//
//  Created by runo on 17/4/6.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController
{
    NSArray *datasource;
    UILabel *label1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    datasource = @[
                       @{@"系统设置":@"prefs:root=INTERNET_TETHERING"},
                       @{@"WIFI设置":@"prefs:root=WIFI"},
                       @{@"蓝牙设置":@"prefs:root=Bluetooth"},
                       @{@"系统通知":@"prefs:root=NOTIFICATIONS_ID"},
                       @{@"通用设置":@"prefs:root=General"},
                       @{@"显示设置":@"prefs:root=DISPLAY&BRIGHTNESS"},
                       @{@"壁纸设置":@"prefs:root=Wallpaper"},
                       @{@"声音设置":@"prefs:root=Sounds"},
                       @{@"隐私设置":@"prefs:root=privacy"},
                       @{@"APP Store":@"prefs:root=STORE"},
                       @{@"Notes":@"prefs:root=NOTES"},
                       @{@"Safari":@"prefs:root=Safari"},
                       @{@"Music":@"prefs:root=MUSIC"},
                       @{@"photo":@"prefs:root=Photos"},
                    @{@"LOCATION_SERVICES":@"prefs:root=LOCATION_SERVICES"},
                       @{@"UIApplicationOpenSettingsURLString":UIApplicationOpenSettingsURLString},
                       @{@"baidu":@"https://www.baidu.com"}
                       ];
    UITableView *tablview = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStylePlain];
    [self.view addSubview:tablview];
    [tablview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tablview.delegate = self;
    tablview.dataSource = self;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight-20, kScreenWidth, 20)];
    label1 = label;
    [self.view addSubview:label1];
    
}

#pragma mark - TableViewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [[datasource[indexPath.row] allKeys] firstObject];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [[datasource[indexPath.row] allValues] firstObject];
    NSURL * url = [NSURL URLWithString:str];
    NSLog(@"%@ %@",str,url);
    if (![[UIApplication sharedApplication] openURL:url]) {
        label1.backgroundColor = [UIColor redColor];
    }else{
        label1.backgroundColor = [UIColor greenColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
