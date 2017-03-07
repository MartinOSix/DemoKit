//
//  ViewController.m
//  RunLoopDemo
//
//  Created by runo on 17/2/24.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "BigImageTableViewCell.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

//static void (*MYRunLoopObserverCallBack)(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);
static void MYRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);


@interface DWURunLoopWorkDistribution : NSObject

@property(nonatomic,strong) NSMutableArray *tasks;
@property(nonatomic,strong) NSMutableArray *tasksKeys;
@property(nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger maximumQueueLength;
@end

#import <objc/runtime.h>

typedef BOOL(^DWURunLoopWorkDistributionUnit)(void);
#define DWURunLoopWorkDistribution_DEBUG 1

@implementation DWURunLoopWorkDistribution

- (void)removeAllTasks {
    [self.tasks removeAllObjects];
    [self.tasksKeys removeAllObjects];
}

- (void)addTask:(DWURunLoopWorkDistributionUnit)unit withKey:(id)key{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    if (self.tasks.count > self.maximumQueueLength) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}

- (void)_timerFiredMethod:(NSTimer *)timer {
    //We do nothing here
}

- (instancetype)init
{
    if ((self = [super init])) {
        _maximumQueueLength = 30;
        _tasks = [NSMutableArray array];
        _tasksKeys = [NSMutableArray array];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_timerFiredMethod:) userInfo:nil repeats:YES];
    }
    return self;
}

+ (instancetype)sharedRunLoopWorkDistribution {
    static DWURunLoopWorkDistribution *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[DWURunLoopWorkDistribution alloc] init];
        [self _registerRunLoopWorkDistributionAsMainRunloopObserver:singleton];
    });
    return singleton;
}

+ (void)_registerRunLoopWorkDistributionAsMainRunloopObserver:(DWURunLoopWorkDistribution *)runLoopWorkDistribution {
    static CFRunLoopObserverRef defaultModeObserver;
    _registerObserver(kCFRunLoopBeforeWaiting, defaultModeObserver, NSIntegerMax - 999, kCFRunLoopDefaultMode, (__bridge void *)runLoopWorkDistribution, &_defaultModeRunLoopWorkDistributionCallback);
}

static void _registerObserver(CFOptionFlags activities, CFRunLoopObserverRef observer, CFIndex order, CFStringRef mode, void *info, CFRunLoopObserverCallBack callback) {
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        info,
        &CFRetain,
        &CFRelease,
        NULL
    };
    observer = CFRunLoopObserverCreate(     NULL,
                                       activities,
                                       YES,
                                       order,
                                       callback,
                                       &context);
    CFRunLoopAddObserver(runLoop, observer, mode);
    CFRelease(observer);
}

static void _runLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    DWURunLoopWorkDistribution *runLoopWorkDistribution = (__bridge DWURunLoopWorkDistribution *)info;
    if (runLoopWorkDistribution.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && runLoopWorkDistribution.tasks.count) {
        DWURunLoopWorkDistributionUnit unit  = runLoopWorkDistribution.tasks.firstObject;
        result = unit();
        [runLoopWorkDistribution.tasks removeObjectAtIndex:0];
        [runLoopWorkDistribution.tasksKeys removeObjectAtIndex:0];
    }
}

static void _defaultModeRunLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    _runLoopWorkDistributionCallback(observer, activity, info);
}

@end

@interface UITableViewCell (DWURunLoopWorkDistribution)

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation UITableViewCell (DWURunLoopWorkDistribution)

- (NSIndexPath *)currentIndexPath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, @selector(currentIndexPath));
    return indexPath;
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    objc_setAssociatedObject(self, @selector(currentIndexPath), currentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tabelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
    self.tabelView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStylePlain];
    [self.view addSubview:self.tabelView];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tabelView];
}

#pragma mark - TableViewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentIndexPath = indexPath;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"big" ofType:@"png"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [ViewController task_5:cell indexPath:indexPath];
    [ViewController task_1:cell indexPath:indexPath];
    [[DWURunLoopWorkDistribution sharedRunLoopWorkDistribution]addTask:^BOOL{
        if (![cell.currentIndexPath isEqual:indexPath]) {
            return NO;
        }
        [ViewController task_2:cell indexPath:indexPath];
        return YES;
    } withKey:indexPath];
    [[DWURunLoopWorkDistribution sharedRunLoopWorkDistribution]addTask:^BOOL{
        if (![cell.currentIndexPath isEqual:indexPath]) {
            return NO;
        }
        [ViewController task_3:cell indexPath:indexPath];
        return YES;
    } withKey:indexPath];
    [[DWURunLoopWorkDistribution sharedRunLoopWorkDistribution]addTask:^BOOL{
        if (![cell.currentIndexPath isEqual:indexPath]) {
            return NO;
        }
        [ViewController task_4:cell indexPath:indexPath];
        return YES;
    } withKey:indexPath];

    return cell;
    
}

+(void)task_5:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    for (int i = 1; i < 5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
}

+(void)task_1:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd-Drawing index is top priority",indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 1;
    [cell.contentView addSubview:label];
}

+(void)task_3:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 30, 85, 85)];
    imageView.tag = 3;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"big" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:^(BOOL finished) {
        
    }];
}

+(void)task_2:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 85, 85)];
    imageView.tag = 2;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"big" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:^(BOOL finished) {
        
    }];
}

+(void)task_4:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 30, 85, 85)];
    imageView.tag = 4;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"big" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:^(BOOL finished) {
        
    }];
}




/**Runloop模式的监听*/
-(void)test{
    
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    CFRunLoopObserverRef runloopObserver
        = CFRunLoopObserverCreate(NULL,//监听者大小，反正可以NULL
             kCFRunLoopAllActivities,//监听的模式
                                  YES,//是否重复监听
                                  NSIntegerMax-999,//监听优先级
                                  &MYRunLoopObserverCallBack,//回调函数
                                  &context);//上下文内容
    //添加观察者
    CFRunLoopAddObserver(CFRunLoopGetCurrent(),//所监听的runloop
                         runloopObserver,//监听者
                         kCFRunLoopDefaultMode);
    //不知道为什么release之后还有用
    CFRelease(runloopObserver);
}

@end

static void MYRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    
    ViewController *vc = ((__bridge ViewController *)info);
    
    if (activity & kCFRunLoopBeforeTimers) {
        NSLog(@"kCFRunLoopBeforeTimers");
    }else if (activity & kCFRunLoopBeforeSources ){
        NSLog(@"kCFRunLoopBeforeSources");
    }else if (activity & kCFRunLoopBeforeWaiting){
        NSLog(@"kCFRunLoopBeforeWaiting");
    }else if (activity & kCFRunLoopAfterWaiting){
        NSLog(@"kCFRunLoopAfterWaiting");
    }else if (activity & kCFRunLoopExit){
        NSLog(@"kCFRunLoopExit");
    }
    
}























