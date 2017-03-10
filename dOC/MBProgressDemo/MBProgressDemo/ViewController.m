//
//  ViewController.m
//  MBProgressDemo
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface DemoC : UIView

@property(nonatomic,strong)NSString *name;
@property(nonatomic,class,assign,readonly) NSInteger count;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 50, 100, 30);
    [btn setTitle:@"btntitle" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    /*
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [view startAnimating];
    [self.view addSubview:view];
    */
    
    
    
    self.view.backgroundColor = [UIColor blackColor];
    //[self btnclick];
    
    DemoC *c = [[DemoC alloc]initWithFrame:CGRectZero];
    NSLog(@"%ld",(long)[DemoC count]);
}



-(void)btnclick{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"哈哈";
    hud.customView = ({
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(10, 100, 300, 300);
        view.backgroundColor = [UIColor yellowColor];
        view;
    });
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.graceTime = 3;
    hud.labelFont = [UIFont systemFontOfSize:20];
    hud.labelColor = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor blackColor];
    hud.opacity = 1;
    hud.progress = 0.5;
    hud.color = [UIColor redColor];
    //hud.xOffset = 100;
    //hud.yOffset = 100;
    hud.dimBackground = YES;
    //hud.graceTime = 5;
    //hud.taskInProgress = YES;
    //hud.minShowTime = 10;
    //hud.square = YES;
    
    hud.minSize = CGSizeMake(100, 200);
    hud.detailsLabelText = @"detail";
    //[hud hide:YES afterDelay:2];
    
    DemoC *c = [[DemoC alloc]init];
    [c setValue:@"haha" forKey:@"name"];
    NSLog(@"%@",[c valueForKey:@"name"]);
    
    
    
    
    NSLog(@"%@",[self sortArrar:@[@1,@3,@7,@2,@0,@5,@4,@6]]);
    
}




-(NSArray *)sortArrar:(NSArray *)arr{
    
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    NSInteger key = 0;
    NSInteger i = 0;
    NSInteger j = arr.count-1;
    BOOL fromRight = YES;
    if (arr.count == 1) {
        return arr;
    }
    
    while (i < j) {
        
        
            if ([marr[key] integerValue] > [marr[j] integerValue] && fromRight) {
                
                [marr exchangeObjectAtIndex:key withObjectAtIndex:j];
                key = j;
                fromRight = NO;
                i++;
                continue;
            }
        
            if ([marr[key] integerValue] < [marr[i] integerValue] && !fromRight) {
                [marr exchangeObjectAtIndex:key  withObjectAtIndex:i];
                key = i;
                fromRight = YES;
                j--;
                continue;
            }
        NSLog(@"%@",marr);
        if (fromRight) {
            j -- ;
        }else{
            i++;
        }
        
    }
    
    NSMutableArray *marr2 = [NSMutableArray array];
    
    if (key == 0) {
        [marr2 addObject:marr[key]];
        [marr2 addObjectsFromArray:[self sortArrar:[marr subarrayWithRange:NSMakeRange(1, marr.count-1)]]];
        return marr2;
    }else if(key == marr.count-1){
        [marr2 addObjectsFromArray:[self sortArrar:[marr subarrayWithRange:NSMakeRange(0, marr.count-1)]]];
        [marr2 addObject:marr[key]];
        return marr2;
    }else{
        
        [marr2 addObjectsFromArray:[self sortArrar:[marr subarrayWithRange:NSMakeRange(0, key)]]];
        [marr2 addObject:marr[key]];
        [marr2 addObjectsFromArray:[self sortArrar:[marr subarrayWithRange:NSMakeRange(key+1, marr.count-key-1)]]];
        return marr2;
    }
    
}





@end

@implementation DemoC

@synthesize name = _name;

static NSInteger _count = 0;


+(NSInteger)count{
    return _count;
}



-(void)setName:(NSString *)name{
    NSLog(@"set");
    _name = name;
}

-(NSString *)name{
    NSLog(@"get");
    return @"hehe";
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _count ++;
    }
    return self;
}

@end
