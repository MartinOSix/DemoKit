//
//  ViewController.m
//  CQFramework
//
//  Created by runo on 16/10/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "CQFramework.h"
#import "CQCheckButton.h"
#import "NSString+CQExtension.h"
#import "NSAttributedString+CQExtension.h"
#import "NSDate+CQExtention.h"
#import "CQNUD.h"
#import "CQJsonParser.h"
#import "RunoAFHelper.h"
#import "CQAFNetworkHelper.h"
#import "CQResponseResult.h"
#import "UIImage+CQExtention.h"
#import "testAlert.h"
#import "AppDelegate.h"
#import "ViewControllerB.h"
#import "CustomPushAnimation.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface ViewController ()<UINavigationControllerDelegate>

@property CQAFNetworkHelper *helper;

@end

@implementation ViewController{
    BOOL isNet;
    UIImageView *imgV;
    testAlert *alert;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self testAlertView];
}

-(void)testAlertView{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = kOrangeColor;
    [btn addTarget:self action:@selector(testAlertViewBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    alert = [[testAlert alloc]initWithFrame:CGRectMake(100, 0, 200, 200)];
    alert.center = self.view.cqFrame_cornerCenter;
    alert.cqCanClickBackgroundExit = YES;
    alert.showType = BaseAlertShowAnimateTypeFormDown;
    alert.backgroundColor = [UIColor redColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 50, 50);
    btn2.backgroundColor = kOrangeColor;
    [btn2 addTarget:self action:@selector(testAlertViewBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    [alert addSubview:btn2];
    
}

-(void)testAlertViewBtnClick2{
    
    [self.navigationController pushViewController:[ViewController new] animated:YES];
    
}

-(void)testAlertViewBtnCLick{
    //[alert cqShowAtController:self];
    
    //测试切换根视图
    //
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //self.navigationController.delegate = self;
    /*
    CATransition *tra = [CATransition animation];
    tra.duration = 10;
    tra.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault
                          ];
    tra.type = kCATransitionMoveIn;
    tra.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:tra forKey:@"animation"];
    */
    ViewControllerB *vb =  [ViewControllerB new];
    vb.cqStatusBarType = CQStatusBarTypeWhite;
    [self.navigationController pushViewController:vb animated:YES];
    
    
    //[dele changeRootController:[ViewControllerB new] FromVC:self.navigationController Animate:YES];
    //[dele changeRootController:[ViewControllerB new] Animate:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                             animationControllerForOperation:(UINavigationControllerOperation)operation
                                                          fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    
    if(operation == UINavigationControllerOperationPush){
        return [[CustomPushAnimation alloc]initWithIsPush:YES];
    }else{
        return [[CustomPushAnimation alloc]initWithIsPush:NO];
    }
    
}

-(void)testImage{
    //UIImage *image = [UIImage imageNamed:@"sys.png"];
    UIImage *image = [UIImage imageNamed:@"IMG_1564.JPG"];
    NSLog(@"1 %lf",UIImagePNGRepresentation(image).length/1024.f);
    imgV = [[UIImageView alloc]initWithImage:image];
    imgV.frame = kScreenBounds;
    [self.view addSubview:imgV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = kOrangeColor;
    [btn addTarget:self action:@selector(testImagebtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)testImagebtnClick{
    
    UIImage *img = [imgV.image cqScaleImageWithRate:0.1];
    imgV.image = img;
    
}


-(void)testAFNetHelper{
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:[CQJSONParser objToJsonString:@"18720135586"] forKey:@"regTel"];
    [dic setObject:[CQJSONParser objToJsonString:@"123123"] forKey:@"password"];
    [dic setObject:[CQJSONParser objToJsonString:@""] forKey:@"tokenID"];
    [dic setObject:@"Login" forKey:@"svcName"];
    
    /*
     self.helper = [RunoAFHelper rnPostParameter:dic Result:^(ResponseResult *result) {
       
        NSLog(@"%@",result);
        
    }];
    */
    
    CQAFNetworkHelper *helper = [[CQAFNetworkHelper alloc]init];
    
    helper.postURL = @"http://blog.codinglabs.org/articles/2048-ai-analysis.html?utm_source=rss&amp;amp;utm_medium=rss&amp;amp;utm_campaign=rss&f=http://blogread.cn/";
    [helper cqPostParameter:nil CompleteBlock:^(CQResponseResult *result) {
    
        
        if (!result.isSuccess) {
            pNSLog(@"%@",result.errorInfo);
        }
        //NSLog(@"%@",[[NSString alloc]initWithData:result.resultData encoding:NSUTF8StringEncoding]);
    }];
    
    [CQAFNetworkHelper cqCloseAllTask];
    
}


-(void)testJson{
    
    NSString *str = @"\"哈哈哈哈\n\"";
    NSLog(@"%@",[CQJSONParser objToJsonString:str]);
    NSDictionary *dic = @{@"1234":@"2341"};
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSLog(@"%@",[CQJSONParser objFromJsonString:@"{\"哈哈哈\":abc}"]);
    
    
}

-(void)testDate{
    
   NSDate *date =  [NSDate cqCSTDate];
    NSLog(@"date %@",date);
    NSString *gmtStr = [date cqToGMTDateStringWithFormat:CQDateFromatType1];
    NSLog(@"%@",gmtStr);
    gmtStr = @"2016-11-28 17:42:34";
    NSDate *gmtDate = [NSDate cqGetGMTDateFromCSTString:gmtStr Type:CQDateFromatType1];
    NSLog(@"gmtDate %@",gmtDate);
    
    if ([NSDate cqCompareDate:gmtDate AndDate:date] == NSOrderedDescending) {
        NSLog(@">");
    };
    
    NSLog(@"%lf \n %d",[NSDate cqIntervalByDate:gmtDate AndDate:date],8*60*60);
    
    NSLog(@"%lf \n %d",[NSDate cqIntervalByDateString:@"11-27 17:32" AndDateString:@"11-28 17:32" Type:CQDateFromatType8],24*60*60);
    
    if ([NSDate cqCompareDateString:@"11-27 17:32" AndDateString:@"11-28 17:32" Type:CQDateFromatType8] == NSOrderedAscending) {
        NSLog(@"<");
    }
    
    if([NSDate cqIsSameDay:gmtDate date2:date]){
        NSLog(@"是同一天");
    }else{
        NSLog(@"不是同一天");
    }
    
    gmtDate = [NSDate cqCSTDate];
    NSLog(@"%ld  %ld  %ld  %ld  %ld  %ld",(long)gmtDate.cqGMTYear,(long)gmtDate.cqGMTMonth,(long)gmtDate.cqGMTDay,(long)gmtDate.cqGMTHour,(long)gmtDate.cqGMTMinute,(long)gmtDate.cqGMTSecond);
    
    NSLog(@"%ld  %ld  %ld  %ld  %ld  %ld",(long)[gmtDate cqDateByAddingYears:10].cqGMTYear,(long)[gmtDate cqDateByAddingMonths:10].cqGMTMonth,(long)[gmtDate cqDateByAddingDays:10].cqGMTDay,(long)[gmtDate cqDateByAddingHours:10].cqGMTHour,(long)[gmtDate cqDateByAddingMinutes:10].cqGMTMinute,(long)
          [gmtDate cqDateByAddingSeconds:10].cqGMTSecond);
    
    NSLog(@"%@",[NSDate cqCreateDateByYear:2016 Month:0 Day:0 Hour:0 Min:6 Second:6]);
    
    NSDate *testDate = [NSDate cqCreateDateByYear:2016 Month:11 Day:29 Hour:10 Min:6 Second:6];
    NSLog(@"%@",testDate);
    NSLog(@"%d",[testDate cqIsToday]);
    NSLog(@"%d",[testDate cqIsYesterday]);
    NSLog(@"%d",[testDate cqIsBeforeYesterday]);
    
    NSLog(@"%@",[NSDate cqIntervalStringByInterval:[testDate cqCSTDateToGMTDate].timeIntervalSinceNow]);
}

-(void)testArray{
    
    NSString *str = @"123";
    
    NSArray *arr = @[str,str,str];
    for (NSString *t in arr) {
        
        NSLog(@"%@",t);
        if ([arr lastObject] == t) {
            break;
        }
    }
    NSLog(@"%d",arr.count);
    
}

-(void)testUserDefault{
    
    [CQNUD cqRemoveValueFromKey:@"123"];//删除一个不存在的 不会出问题
    
}

-(void)testString{
    
    //测试trim
    NSString *str = @"  a d s f b\n  ";
    NSLog(@"%@",str);
    NSString *newStr = [str cqTrim];
    NSLog(@"%@",newStr);
    
    //测试attributeString大小
    NSAttributedString *astr1 = [NSAttributedString cqCreateAStrWith:@"哈哈哈哈哈哈哈哈哈哈哈" FontSize:16];
    NSAttributedString *astr2 = [NSAttributedString cqCreateAStrWith:@"呵呵呵呵呵呵呵呵" FontSize:30];
    NSMutableAttributedString *mastr = [[NSMutableAttributedString alloc]initWithAttributedString:astr1];
    [mastr appendAttributedString:astr2];
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.attributedText = mastr;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 1;
    
    CGRect size = [mastr boundingRectWithSize:CGSizeMake(150, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    label.frame = size;
    
}

-(void)testBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 50, 70, 30);
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.backgroundColor = kRedColor;
    [btn addTarget:self action:@selector(testStatusBar) forControlEvents:UIControlEventTouchUpInside];
    
    CQCheckButton *btn1 = [[CQCheckButton alloc]initWithFrame:CGRectMake(100, 100, 100, 30) Title:@"汽车"];
    [btn1 cqShowBorder];
    [self.view addSubview:btn1];
    
    //    NSLog(@"%@\n%@\n%@",[CQCommonUtiles cqGetCachePath],[CQCommonUtiles cqGetLibraryPath],[CQCommonUtiles cqGetDocumentPath]);
    //    NSLog(@"%@",NSHomeDirectory());
    
    NSLog(@"%@",[CQCommonUtiles cqGetCitysByProvince:@"江西省"]);
    NSLog(@"%@",@{@"圣诞节福利":@"爱丽丝看风景的"});
    //[self testNet];
    
}

-(void)testStatusBar{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] setNeedsStatusBarAppearanceUpdate];
}

-(void)testAlert{
    
    //[CQCommonUtiles cqShowWarningAlert:@"this is warning alert"];
    //[CQCommonUtiles cqShowTipsAlert:@"this is tips alert"];
    //[CQCommonUtiles cqShowTipsAlert:@"this is tipstitle alert" Title:@"title"];
//    [CQCommonUtiles cqShowTipsAlert:@"message" AtController:self YesAction:^{
//        NSLog(@"yes action");
//    }];
//    [CQCommonUtiles cqShowYesOrNoAlert:self Title:@"Title" Message:@"message" Yes:^{
//        NSLog(@"yes click");
//    } No:^{
//        NSLog(@"no click");
//    }];
    
//    [CQCommonUtiles cqShowYesOrNoSheet:self Title:@"title" Message:@"message" Yes:^{
//        NSLog(@"yes click");
//    } No:^{
//        NSLog(@"no click");
//    }];
    
    [CQCommonUtiles cqShowYesOrNoTextAlert:self Title:@"title" Message:@"message" Yes:^(UITextField *textTF) {
        NSLog(@"%@",textTF.text);
        if ([textTF.text isEqualToString:@"warning"]) {
            [CQCommonUtiles cqShowWarningAlert:@"warning"];
        }
    } No:^(UITextField *textTF) {
        NSLog(@"%@",textTF.text);
    }];
    
}

-(void)testNet{//测试网络
    NSLog(@"-out-%p",[NSThread currentThread]);
    
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        NSLog(@"-in-%p",[NSThread currentThread]);
        [CQCommonUtiles cqStartNetworkStatusListener:^(NSString *networkStatus) {
            kNSLog(@"%@",networkStatus);
        }];
        
    });
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        while (1) {
            sleep(5);
            if ([CQCommonUtiles cqIsConnectNetwork]) {
                kNSLog(@"有网");
                isNet = YES;
            }else{
                kNSLog(@"没网");
                isNet = NO;
            }
            kDISPATCH_MAIN_THREAD(^{
                [[[[UIApplication sharedApplication] keyWindow] rootViewController] setNeedsStatusBarAppearanceUpdate];
            });
            
        }
    });
    
}


-(BOOL)prefersStatusBarHidden{
    //在当前Controller中需要更新状态时需要在主线程执行该方法
    //[[[[UIApplication sharedApplication] keyWindow] rootViewController] setNeedsStatusBarAppearanceUpdate];
    return  NO;
}

@end
