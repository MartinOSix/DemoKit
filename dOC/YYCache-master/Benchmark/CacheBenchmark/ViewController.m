//
//  ViewController.m
//  CacheBenchmark
//
//  Created by ibireme on 15/10/20.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "ViewController.h"
#import "Benchmark.h"
#import "YYCache.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface Person : NSObject <NSCoding>
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger age;
@end

@implementation Person

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.age = [aDecoder decodeIntegerForKey:@"age"];
    return self;
}

@end

@interface ViewController ()

@property(nonatomic,strong)YYDiskCache *mycache;

@end

@implementation ViewController{
    UITextView *textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textView = [[UITextView alloc]initWithFrame:kScreenBounds];
    
    [self.view addSubview:textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, kScreenHeight-30, 100, 30);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    self.mycache = [[YYDiskCache alloc]initWithPath:path];
    NSLog(@"%@",path);
    Person *p = (Person *)[self.mycache objectForKey:@"pp"];
    textView.text = [NSString stringWithFormat:@"name %@ \nage %zd",p.name,p.age];
    
}

-(void)btnClick{
    
    NSLog(@"%@",NSHomeDirectory());
    Person *p = [[Person alloc]init];
    p.name = textView.text;
    p.age = arc4random()%30;
    [self.mycache setObject:p forKey:@"pp"];
    
}

@end
