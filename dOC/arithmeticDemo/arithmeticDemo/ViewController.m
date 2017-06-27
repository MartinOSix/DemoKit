//
//  ViewController.m
//  arithmeticDemo
//
//  Created by runo on 17/6/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger sourceDataCount = 10;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < sourceDataCount; i ++) {
        [arr addObject:@(arc4random()%sourceDataCount)];
    }
    arr = [NSMutableArray arrayWithArray:@[@(49),@(38),@(65),@(97),@(76),@(13),@(27),@(49),@(55),@(04)]];
    
    //插入排序 -- 直接插入排序
    NSDate *date = [NSDate date];
    //[self inserSort:arr];
    NSTimeInterval interval = [date timeIntervalSinceNow];
    NSLog(@"insertDate  %.5f",interval);
    
    //插入排序 -- 希尔排序
    date = [NSDate date];
    NSArray *shellArr = [self shellSort:[arr mutableCopy]];
    interval = [date timeIntervalSinceNow];
    NSLog(@"insertShellDate  %.5f",interval);
    
    //冒泡排序
    date = [NSDate date];
    //[self popSort:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"popDate  %.5f",interval);
    //选择排序
    date = [NSDate date];
    //[self selectSort:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"selectSort  %.5f",interval);
    //快速排序
    date = [NSDate date];
    //NSArray *result = [self quickSort:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"quickSort  %.5f",interval);
    //NSLog(@"%@",result);
    
    
    //快速排序2
    NSMutableArray *arr2 = [arr mutableCopy];
    date = [NSDate date];
    //[self quickSort2:arr2 LeftIndex:0 RightIndex:arr.count-1];
    interval = [date timeIntervalSinceNow];
    NSLog(@"quickSort2  %.5f",interval);


    //快速排序3
    date = [NSDate date];
    //[self quickSort3:[arr mutableCopy] LeftIndex:0 RightIndex:arr.count-1];
    interval = [date timeIntervalSinceNow];
    NSLog(@"quickSort3  %.5f",interval);
}

- (NSArray *)shellSort2:(NSMutableArray *)arr{

    NSInteger gap = arr.count/2;
    
    for (NSInteger i = 0; i < arr.count; i += gap) {
        
    }
    return nil;
}

- (NSArray *)shellSort:(NSMutableArray *)arr{
    
    NSInteger gap = arr.count/2;
    
    while (1 <= gap) {
        for (NSInteger i = gap; i < arr.count; i++) {
            NSInteger j = i - gap;
            NSInteger tmpValue = [arr[i] integerValue];
            //每次遍历完之后
            while (j >= 0 && tmpValue < [arr[j] integerValue]) {
                arr[j + gap] = arr[j];
                j -= gap;
            }
            arr[j+gap] = @(tmpValue);
            //NSLog(@"%@",arr);
        }
        gap /= 2;
        NSLog(@"%@",arr);
    }
    return nil;
}



//快速排序3
- (void)quickSort3:(NSMutableArray *)marr LeftIndex:(NSInteger)left RightIndex:(NSInteger)right{
    
    if (right <= left) {
        return;
    }
    NSInteger headIndex = left;
    NSInteger footIndex = right;
    NSInteger arcIndex = arc4random()%(right-left+1)+left;
    NSInteger key = [[marr objectAtIndex:arcIndex] integerValue];
    
    //分离左右
    while (headIndex < footIndex) {
        
        while ([marr[headIndex] integerValue] <= key && headIndex < footIndex && arcIndex != headIndex) {
            headIndex ++;
        }
        //arcIndex 指向的始终是key的下标
        [marr exchangeObjectAtIndex:headIndex withObjectAtIndex:arcIndex];
        arcIndex = headIndex;
        while ([marr[footIndex] integerValue] >= key && headIndex < footIndex)   {
            footIndex --;
        }
        [marr exchangeObjectAtIndex:footIndex withObjectAtIndex:arcIndex];
        arcIndex = footIndex;
    }
    
    [self quickSort3:marr LeftIndex:left RightIndex:arcIndex-1];
    [self quickSort3:marr LeftIndex:arcIndex+1 RightIndex:right];
}

//快速排序2  这个比快排1快一倍
- (void)quickSort2:(NSMutableArray *)marr LeftIndex:(NSInteger)left RightIndex:(NSInteger)right{
    
    if (right <= left) {
        return;
    }
    NSInteger headIndex = left;
    NSInteger footIndex = right;
    NSInteger key = [[marr objectAtIndex:left] integerValue];
    
    //判断有没有找完
    while (headIndex < footIndex) {
        
        
        while ([marr[footIndex] integerValue] >= key && headIndex < footIndex)  {
            footIndex--;
        }
        marr[headIndex] = marr[footIndex];
        while ([marr[headIndex] integerValue] <= key && headIndex < footIndex) {
            headIndex++;
        }
        marr[footIndex] = marr[headIndex];
        
    }
    marr[headIndex] = @(key);
    [self quickSort2:marr LeftIndex:left RightIndex:headIndex-1];
    [self quickSort2:marr LeftIndex:headIndex+1 RightIndex:right];
}


//快速排序
- (NSArray *)quickSort:(NSArray *)arr{
    
    if (arr.count <= 1) {
        return arr;
    }
    //将第一个数当做中间数
    NSInteger firstObj = [[arr firstObject] integerValue];
    //左边都是小于中间数的数组
    NSMutableArray *leftMarr = [NSMutableArray array];
    //右边都是大于中间数的数组
    NSMutableArray *rightMarr = [NSMutableArray array];
    
    //将原数组中的数据和中间数进行比较得出左右两边数组
    for (int i = 1; i < arr.count; i++) {
        if ([arr[i] integerValue]<firstObj) {
            [leftMarr addObject:arr[i]];
        }else{
            [rightMarr addObject:arr[i]];
        }
    }
    NSMutableArray *marr = [NSMutableArray array];
    [marr addObjectsFromArray:[self quickSort:leftMarr]];
    [marr addObject:@(firstObj)];
    [marr addObjectsFromArray:[self quickSort:rightMarr]];
    return [marr copy];
}

//选择排序
- (void)selectSort:(NSArray *)arr{
    
    //有n个待排数字的数组
    NSMutableArray *marr = [arr mutableCopy];
    //从寻找最小数字的次数
    for (int i = 0; i < marr.count; i++) {
        NSInteger minIndex = i;
        for (int j = i; j < marr.count; j++) {
            //找到后面最小元素下标
            NSInteger min = [marr[minIndex] integerValue];
            NSInteger current = [marr[j] integerValue];
            if (current < min) {
                minIndex = j;
            }
        }
        //将最小的元素放在前面
        [marr exchangeObjectAtIndex:minIndex withObjectAtIndex:i];
    }
    
}

//冒泡排序
- (void)popSort:(NSArray *)arr{
    
    NSMutableArray *marr = [arr mutableCopy];
    
    //排序次数
    for (int i = 0; i < marr.count; i++) {
        //从列表中第一个数字到最后一个没有拍好的数字
        for (int j = 0; j < marr.count-i-1; j++) {
            //如果前面的大于后面的，就交换
            NSInteger first = [marr[j] integerValue];
            NSInteger seconde = [marr[j+1] integerValue];
            if (first > seconde) {
                [marr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
}

//插入排序
- (NSArray *)inserSort:(NSArray *)arr{
    
    //首先建立一个空表，表示这个有序集合
    NSMutableArray *newArr = [NSMutableArray array];
    //将数组中第一个元素放入新列表，当做有序集合的第一个元素
    [newArr addObject:[arr firstObject]];
    
    //遍历需要排序的数组获取排序元素
    for (int j = 1; j < arr.count; j++) {
        NSInteger srcObj = [arr[j] integerValue];
        //遍历新数组，找到对应位置放置排序元素
        for (int i = 0; i < newArr.count; i++) {
            NSInteger obj = [newArr[i] integerValue];
            if (srcObj <= obj) {
                [newArr insertObject:@(srcObj) atIndex:i];
                break;
            }else if (i == newArr.count-1){
                [newArr addObject:@(srcObj)];
                break;//不加break，你通过addobject改变了newArr.cout的值，所以会有两个当前最大值
            }
        }
    }
    return [newArr copy];
}


@end
