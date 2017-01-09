//
//  ViewController_Center.m
//  blueToothDemo
//
//  Created by runo on 17/1/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController_Center.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController_Center () <CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong) CBCentralManager *centerManager;
@property(nonatomic,strong) NSMutableArray *foundPeripherals;
@property(nonatomic,strong) NSTimer *scanLimitTimer;
@property(nonatomic,strong) CBPeripheral *connectionPeripheral;

@end

@implementation ViewController_Center

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //1、初始化中心管理器
    self.centerManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
    self.foundPeripherals = [NSMutableArray array];

}

#pragma mark - CenterManagerDelegate
/**蓝牙中心状态改变*/
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
            //2、开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
        {
            [self.centerManager scanForPeripheralsWithServices:nil options:nil];
            //2.1、设置扫描超时时间
            self.scanLimitTimer = [NSTimer scheduledTimerWithTimeInterval:30 repeats:NO block:^(NSTimer * _Nonnull timer) {
                if (self.centerManager.isScanning) {
                    [self.centerManager stopScan];
                    NSLog(@"-发现的外设数量-%lu",(unsigned long)self.foundPeripherals.count);
                }
            }];
        }
            break;
        default:
            break;
    }
}

/**发现外设*/
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"当扫描到设备:%@",peripheral.name);
    NSLog(@"%@",advertisementData);
    //3、保存一发现的设备
    [self.foundPeripherals addObject:peripheral];
    //4、连接发现的设备
    if ([peripheral.name isEqualToString:@"MI Band 2"]) {
        [self.centerManager stopScan];
        [self.centerManager connectPeripheral:peripheral options:nil];
    }
    
}
/**连接外设失败*/
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //没有“超时失败”
}
//连接断开
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
}
//5.连接外设成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"连接外设成功");
    peripheral.delegate = self;
    self.connectionPeripheral = peripheral;
    //6、发现外设中的服务
    [peripheral discoverServices:nil];;
}

#pragma mark - PeripheralDelegate
//在外设中发现服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSLog(@"%@",peripheral.services);
    for (CBService *service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:@"FEE1"]) {
            //去发现特性
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}
//在服务中发现特性
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"%@",service);
    NSLog(@"%@",service.characteristics);
    //0000FEC1-0000-3512-2118-0009AF100700
    for (CBCharacteristic *character in service.characteristics) {
        if ([character.UUID.UUIDString isEqualToString:@"0000FEC1-0000-3512-2118-0009AF100700"]
           //判断是否客服权限
            && (character.properties & CBCharacteristicPropertyRead)
            ) {
            //读取特性值
            [peripheral readValueForCharacteristic:character];
            
            if (character.properties & CBCharacteristicPropertyNotify) {
                //接收特性的通知
                [peripheral setNotifyValue:YES forCharacteristic:character];
            }
            
            if (character.properties & CBCharacteristicPropertyWrite) {
                //写数据
                [peripheral writeValue:[@"martin" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:character type:CBCharacteristicWriteWithResponse];
            }
        }
    }
    
}

//读取特性属性
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if(!error){
        NSData *data = characteristic.value;
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
    }else{
        NSLog(@"read Value error %@",error.localizedDescription);
    }
}

//接收到通知特性的通知
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"updata notification state error %@",error.localizedDescription);
        return;
    }else{
        NSData *data = characteristic.value;
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
    }
}

//写入数据回调
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"write value error %@",error.localizedDescription);
        return;
    }else{
        NSLog(@"write success");
    }
    
}

@end
