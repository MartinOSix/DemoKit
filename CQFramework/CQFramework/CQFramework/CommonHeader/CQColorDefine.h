//
//  CQColorDefine.h
//  AVPlayer
//
//  Created by runo on 16/6/23.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#ifndef CQColorDefine_h
#define CQColorDefine_h

//颜色处理
#define kBlackColor     [UIColor blackColor]
#define kBlueColor      [UIColor blueColor]
#define kBrownColor     kCustomerColor(119,107,95)
#define kClearColor     [UIColor clearColor]
#define kGreenColor     [UIColor greenColor]
#define kGrayColor      [UIColor grayColor]
#define kMainColor      kCustomerColor(194,84,95)
#define kMauveColor     kCustomerColor(88,75,103) //淡紫色
#define kOrangeColor    [UIColor orangeColor]
#define kPurpleColor    [UIColor purpleColor]
#define kPinkColor      kCustomerColor(245,39,80)
#define kRedColor       [UIColor redColor]
#define kSkyBlueColor   kCustomerColor(124,255,255)
#define kSysLineColor   kCustomerColor(150,170,188)
#define kWhiteColor     [UIColor whiteColor]
#define kYellowColor     kCustomerColor(242,197,117)

#define kLightGrayColor     [UIColor lightGrayColor]
#define kLLigthGrayColor    kCustomerColor(246,246,246) //灰白色
#define kLightBlueColor     kCustomerColor(94,147,196)
#define kLightGreenColor    kCustomerColor(77,216,122)
#define kLightOrangeColor   kCustomerColor(255,137,0)

#define kSysNavBackgroundColor kCustomerColor(248,248,248)
#define kSysBlueColor kCustomerColor(0,122,255)
//kCustomerColorAlpha(cqRed,cqGreen,cqBlue,cqAlpha)

//自定义颜色
#define kCustomerColor(cqRed,cqGreen,cqBlue) [UIColor colorWithRed:cqRed/255.0f green:cqGreen/255.0f blue:cqBlue/255.0f alpha:1]
#define kCustomerColorAlpha(cqRed,cqGreen,cqBlue,cqAlpha) [UIColor colorWithRed:cqRed/255.0f green:cqGreen/255.0f blue:cqBlue/255.0f alpha:cqAlpha]
//随机色
#define kArcColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:(arc4random()%50+30)/100.0f]

// 十六进制颜色
#define kColorFromHexString(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* CQColorDefine_h */
