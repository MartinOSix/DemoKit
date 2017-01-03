//
//  ViewController_Center.m
//  blueToothDemo
//
//  Created by runo on 17/1/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController_Center.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController_Center () <CBCentralManagerDelegate>

@property(nonatomic,strong) CBCentralManager *centerManager;

@end

@implementation ViewController_Center

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];

}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            [self.centerManager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"当扫描到设备:%@",peripheral.name);
    //接下来可以连接设备
}

@end
