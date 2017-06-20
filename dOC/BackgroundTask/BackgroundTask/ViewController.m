//
//  ViewController.m
//  BackgroundTask
//
//  Created by runo on 17/1/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface Father : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) NSInteger age;

-(Father * (^)(int i))add;

@end
@interface Son : Father
@end
@implementation Father{
    NSString *_ha;
}

-(Father * (^)(int i))add{
    return ^(int a){
        _age+=a;
        return self;
    };
}

-(void)haha{
    
}

-(void)nnn{
    NSLog(@"nnnnnn");
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
    if ([NSStringFromSelector(sel) isEqualToString:@"hehe"]) {
        IMP imp = class_getMethodImplementation([self class], @selector(nnn));
        //class_addMethod([self class], sel, imp, "");
        //return YES;
    }
    return NO;
}

-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"hehe"]) {
     //   return [[Son alloc]init];
    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if([NSStringFromSelector(aSelector) isEqualToString:@"hehe"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return nil;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"forword");
}

-(void)doesNotRecognizeSelector:(SEL)aSelector{
    
    NSLog(@"随意啦 %@",NSStringFromSelector(aSelector));
}

@end


@implementation Son

-(instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"self  %@",NSStringFromClass([self.class class]));
        NSLog(@"super  %@",NSStringFromClass([self.superclass class]));
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog([NSString stringWithFormat:@"undefine key %@",key]);
}

-(void)hehe{
    NSLog(@"print son hehe ");
}

@end



@interface ViewController ()

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) UIBackgroundTaskIdentifier backgroundID;
@property(nonatomic,readwrite,assign) NSInteger age;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(mainTask) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    self.age = 13;

    int a[5] = {1, 2, 3, 4, 5};
    int *ptr = (int *)(&a - 1);
    printf("%d",*(a));
    printf("%d, %d", *(a + 1), *(ptr - 1));
    self.age = 20;
    NSLog(@"-- %zd",self.age);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 50, 100, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(startBacgroundTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self testMethod];
}

-(void)testMethod{
    
    Father *son = [[Father alloc]init];
    
    [son haha];
    //[son hehe2345];
    [son performSelector:@selector(hehe2345)];//调用不识别的方法
    
    //BOOL isres = [son respondsToSelector:@selector(hehe)];
    //NSLog(@"isresp   %d",isres);
    
}

-(void)testKVO{
    Father *son = [[Father alloc]init];
    son.add(4).add(76).add(87);
    NSLog(@"change %zd",son.age);
    [son addObserver:self forKeyPath:@"_ha" options:NSKeyValueObservingOptionNew context:nil];
    [son setValue:@"new ha" forKey:@"_ha"];
    int i = 0;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"keyPath %@",keyPath);
    NSLog(@"change %@",change);
    
}

-(void)startBacgroundTask{
    
    NSLog(@"--");
    NSURL * url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:nil ];
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:url withObject:nil];
    /*
    self.backgroundID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"%@",[NSDate date]);
    }];
    */
}

-(void)mainTask{
    
    static int i = 0;
    NSLog(@"--%d",i);
    i++;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
