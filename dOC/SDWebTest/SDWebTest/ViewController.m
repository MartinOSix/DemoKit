//
//  ViewController.m
//  SDWebTest
//
//  Created by runo on 16/12/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface TestInitClass : NSObject

@property(nonatomic,strong)NSString *name;

@end

@implementation TestInitClass

+(instancetype)shareInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

-(id)init{
    return [self initWithName:@"default"];
}

-(id)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

@end


@interface ViewController ()

@property(nonatomic,strong) NSMutableArray *shareData;
@property(nonatomic,strong) NSCache *memCache;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.memCache = ({
        NSCache *cache = [[NSCache alloc]init];
        cache.countLimit = 30;
        cache;
    });
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (int i =0 ; i< 100; i++) {
        // 向缓存中添加对象
        NSString *str = [NSString stringWithFormat:@"hello - %d", i];
        [self.memCache setObject:str forKey:@(i)]; // @(i) 相当于  [NSNumber numberWith......]
    }
    for (int i=0 ; i< 100; i++) {
        NSLog(@"%@", [self.memCache objectForKey:@(i)]);
    }
}


-(void)test1{
    
    NSLog(@"%@",[TestInitClass shareInstance].name);
    
    
    self.shareData = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    //场景：两个线程随机访问同一数组，数组同时只能被一个线程访问，记录访问记录
    dispatch_queue_t queuq = dispatch_queue_create("concurent", DISPATCH_QUEUE_CONCURRENT);
    
    
    
    dispatch_group_async(group,queuq, ^{
        int i = 0;
        //        dispatch_group_enter(group);
        while (i < 20) {
            
            @synchronized (self.shareData) {
                NSLog(@"A开始");
                //for (int j = 0; j < 3; j++) {
                [self.shareData addObject:[NSString stringWithFormat:@"A %d",i]];
                //  sleep(1);
                i++;
                //}
                NSLog(@"A解锁");
            }
            
            
        }
        NSLog(@"%@", [NSString stringWithFormat:@"A %d",i]);
        //        dispatch_group_leave(group);
    });
    
    dispatch_group_async(group,queuq, ^{
        int i = 0;
        //dispatch_group_enter(group);
        while (i < 20) {
            
            @synchronized (self.shareData) {
                NSLog(@"B开始");
                //for (int j = 0; j < 3; j++) {
                [self.shareData addObject:[NSString stringWithFormat:@"B %d",i]];
                //    sleep(1);
                i++;
                //}
                NSLog(@"B解锁");
            }
            
        }
        NSLog(@"%@", [NSString stringWithFormat:@"B %d",i]);
        //        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"%@",self.shareData);
    });
    NSLog(@"哈哈");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
