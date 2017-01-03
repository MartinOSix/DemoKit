//
//  ViewController.m
//  blueToothDemo
//
//  Created by runo on 17/1/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


#define notificationUID @"237ABA52-FD19-EC48-0DAA-B16D364DA6DD"
#define serviceUID1 @"F3E7297D-EC14-9783-1856-27BDF591D6D5"
#define serviceUID2 @"360F7664-9336-ECE7-5B4B-709EE1679015"

#define readWirteUID @"281FC920-894B-56FE-FE46-BA71D04A7FFD"
#define readUID @"19E71F24-42D6-E1CD-17CF-1FA32A7964E0"

@interface ViewController ()<CBPeripheralManagerDelegate>

@property(nonatomic,strong) CBPeripheralManager *perManager;
@property(nonatomic,strong) NSString *ServiceUUID1;
@property(nonatomic,strong) NSString *ServiceUUID2;
@property(nonatomic,assign) NSInteger serviceNum;
@property(nonatomic,strong) NSString *LocalNameKey;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.perManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    self.ServiceUUID1 = serviceUID1;
    self.ServiceUUID2 = serviceUID2;
    self.serviceNum = 0;
    
    self.LocalNameKey = @"qwertyuio";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    switch (peripheral.state) {
        case CBManagerStatePoweredOn:
            NSLog(@"打开蓝牙");
            [self setUpService];
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"关闭蓝牙");
            break;
        default:
            break;
    }
    
}

-(void)setUpService{
    
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    
    /*
     可以通知的Characteristic
     properties：CBCharacteristicPropertyNotify
     permissions CBAttributePermissionsReadable
     */
    NSString *notiyCharacteristicUUID = notificationUID;
    
    CBMutableCharacteristic *notiyCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:notiyCharacteristicUUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];

    /*
     可读写的characteristics
     properties：CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable | CBAttributePermissionsWriteable
     */
    NSString *readwriteCharacteristicUUID = readWirteUID;
    CBMutableCharacteristic *readwriteCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:readwriteCharacteristicUUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    //设置description
    CBMutableDescriptor *readwriteCharacteristicDescription1 = [[CBMutableDescriptor alloc]initWithType: CBUUIDCharacteristicUserDescriptionStringUUID value:@"name"];
    [readwriteCharacteristic setDescriptors:@[readwriteCharacteristicDescription1]];
    
    /*
     只读的Characteristic
     properties：CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable
     */
    NSString *readCharacteristicUUID = readUID;
    CBMutableCharacteristic *readCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:readCharacteristicUUID] properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    
    
    //service1初始化并加入两个characteristics
    
    CBMutableService *service1 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:self.ServiceUUID1] primary:YES];
    [service1 setCharacteristics:@[notiyCharacteristic,readwriteCharacteristic]];
    
    //service2初始化并加入一个characteristics
    
    CBMutableService *service2 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:self.ServiceUUID2] primary:YES];
    [service2 setCharacteristics:@[readCharacteristic]];
    
    //添加后就会调用代理的- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
    
    [self.perManager addService:service1];
    [self.perManager addService:service2];
}

//perihpheral添加了service
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    
    if (error == nil) {
        self.serviceNum++;
    }
    
    //因为我们添加了2个服务，所以想两次都添加完成后才去发送广播
    if (self.serviceNum==2) {
        //添加服务后可以在此向外界发出通告 调用完这个方法后会调用代理的
        //(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
        [self.perManager startAdvertising:@{
                                              CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:self.ServiceUUID1],[CBUUID UUIDWithString:self.ServiceUUID2]],
                                              CBAdvertisementDataLocalNameKey : self.LocalNameKey
                                              }
         ];
        
    }
    
}

//peripheral开始发送advertising
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    NSLog(@"in peripheralManagerDidStartAdvertisiong");
}

//订阅characteristics
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"订阅了 %@的数据",characteristic.UUID);
    //每秒执行一次给主设备发送一个当前时间的秒数
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendData:) userInfo:characteristic  repeats:YES];
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"取消dingyue");
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//发送数据，发送当前时间的秒数
-(BOOL)sendData:(NSTimer *)t {
    CBMutableCharacteristic *characteristic = t.userInfo;
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:@"ss"];
    NSLog(@"%@",[dft stringFromDate:[NSDate date]]);
    
    //执行回应Central通知数据
    return  [self.perManager updateValue:[[dft stringFromDate:[NSDate date]] dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:nil];
    
}

//读characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    NSLog(@"didReceiveReadRequest  ");
    //判断是否有读数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
        //对请求作出成功响应
        [self.perManager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [self.perManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}


/**写characteristics请求*/
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    NSLog(@"didReceiveWriteRequests");
    CBATTRequest *request = requests[0];
    
    //判断是否有写数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
        //需要转换成CBMutableCharacteristic对象才能进行写值
        CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
        NSString *str = [[NSString alloc]initWithData:request.value encoding:NSUTF8StringEncoding];
        NSLog(@"---%@",str);
        c.value = request.value;
        [self.perManager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [self.perManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
    
}
@end
