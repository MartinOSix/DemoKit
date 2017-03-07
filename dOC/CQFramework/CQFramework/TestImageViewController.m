//
//  TestImageViewController.m
//  CQFramework
//
//  Created by runo on 17/2/23.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "TestImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CQFramework.h"

@interface Shop : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)void(^myBlock)();

@end

@implementation Shop

-(void)dealloc{
    NSLog(@"shop dealloc");
}

@end

@interface TestImageViewController ()
@property(nonatomic,strong)NSString *name;
@property(nonatomic,copy)void(^sblock)();
@end

@implementation TestImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"QQ20170223"]];
    self.view.backgroundColor = color;
    */
    NSString *urlString= [NSString stringWithFormat:@"http://www.baidu.com/哈哈"];
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
    NSURL *url = [NSURL URLWithString:encodedString];
    
    NSString *utf8Str = @"https//:www.baidu.com/你好，哈哈哈";
    utf8Str = [utf8Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *unicodeStr = [NSString stringWithCString:[utf8Str UTF8String] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",unicodeStr);
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    UITextField *tg = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 200, 30)];
    tg.backgroundColor = [UIColor orangeColor];
    tg.inputView = datePicker;
    [self.view addSubview:tg];
    self.name = @"haha";
    Shop *shop = [[Shop alloc]init];
    shop.name = @"haha";
    WEAKOBJECT(shop);
    WEAKSELF;
    shop.myBlock = ^(){
        
        self.name = @"hahaha";
//        NSLog(@"%@",weakObj.name);
//        STRONGOBJECT(weakObj);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSLog(@"%@",self.name);
            
        });
    };
    shop.myBlock();
}

-(void)dateChange:(UIDatePicker *)picker{
    NSLog(@"%@",picker.date);
}

@end
