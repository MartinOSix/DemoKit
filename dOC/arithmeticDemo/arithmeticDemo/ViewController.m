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
    NSLog(@"%zd",[self testTrangle:7]);
    NSLog(@"%zd",[self testCountN:30]);
    /*
    NSInteger sourceDataCount = 10;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < sourceDataCount; i ++) {
        [arr addObject:@(arc4random()%(sourceDataCount*10))];
    }
    //arr = [NSMutableArray arrayWithArray:@[@(1),@(10),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9)]];
    
    //Count为数组中最大值的位数
    [self baseSort:arr Count:2];
    
    //插入排序 -- 直接插入排序
    NSDate *date = [NSDate date];
    //[self inserSort:arr];
    NSTimeInterval interval = [date timeIntervalSinceNow];
    NSLog(@"insertDate  %.5f",interval);
    
    //插入排序 -- 希尔排序
    date = [NSDate date];
    //NSArray *shellArr = [self shellSort2:[arr mutableCopy]];
    interval = [date timeIntervalSinceNow];
    NSLog(@"insertShellDate  %.5f",interval);
    
    //交换排序
    date = [NSDate date];
    //[self exchangeSort:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"insertShellDate  %.5f",interval);
    
    //冒泡排序
    date = [NSDate date];
    //[self popSort:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"popDate  %.5f",interval);
    
    //双向冒泡
    date = [NSDate date];
    //[self bothWaySort:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"bothWaySort  %.5f",interval);
    
    //选择排序
    NSMutableArray *marrSelect1 = [arr mutableCopy];
    date = [NSDate date];
    //[self selectSort:marrSelect1];
    interval = [date timeIntervalSinceNow];
    NSLog(@"selectSort  %.5f",interval);
    
    date = [NSDate date];
    //[self selectSort2:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"selectSort  %.5f",interval);
    
    //堆排序
    date = [NSDate date];
    //[self heapSort:arr];
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
    
    
    //归并排序
    date = [NSDate date];
    [self mergeSort:arr];
    interval = [date timeIntervalSinceNow];
    NSLog(@"quickSort3  %.5f",interval);
    */
}


- (NSInteger)testCountN:(NSInteger) n{
    
    //求 N！末尾0的个数
    // f(N!) = k + f(k!) k = N/5 取整 k < 5 f(k!) = 0
    if (n < 5) {
        return 0;
    }else{
        
        return n/5 + [self testCountN:n/5];
        
    }
}

- (NSInteger)testTrangle:(NSInteger) n{
    
    //计算1-n中所有整数组成的不同组合的三角
    int count = 0;
    for (int a = 2; a <= n-2; a++) {
        for (int b = a+1; b <= n-1; b++) {
            for (int c = b+1; c <= n; c++) {
                if ( a+b > c &&
                     a+c > b &&
                     c-b < a &&
                     c-b < a
                    ) {
                    NSLog(@"a %d,b %d,c %d",a,b,c);
                    count++;
                }
            }
        }
    }
    return count;
}

- (void)mergeTest{
    
    
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@(1),@(4),@(6),@(8),@(2),@(5),@(17)]];
    NSInteger helpLeft = 0;
    NSInteger helpRight = 3+1;
    NSInteger current = 0;
    NSMutableArray *harr = [NSMutableArray arrayWithArray:arr];
    
    while (helpLeft <= 3 && helpRight <= 6) {
        
        if ([harr[helpLeft] integerValue] <= [harr[helpRight] integerValue]) {
            arr[current] = harr[helpLeft];
            helpLeft++;
        }else{
            arr[current] = harr[helpRight];
            helpRight++;
        }
        current++;
    }
    NSLog(@"%@  %zd",arr,helpLeft);
    
}

- (void)mergeSort:(NSMutableArray *)marr{
    
    /*
     归并排序：是将数组切分成若干个小数组，分别对若干个小数组进行排序，然后，依次合并小数组，并重新排序，重复合并小数组，最后合并成一个数组
     */
    NSMutableArray *hmarr = [NSMutableArray array];
    
    
    __block void(^SortArr)(NSMutableArray *srcArr,NSMutableArray *desArr,NSInteger head,NSInteger foot,NSInteger middle) = ^void(NSMutableArray *srcArr,NSMutableArray *desArr,NSInteger head,NSInteger foot,NSInteger middle){

        for (NSInteger i = head; i<=foot; i++) {
            desArr[i] = srcArr[i];
        }
        NSInteger helpLeft = head;
        NSInteger helpRight = middle+1;
        NSInteger current = head;
        //对数组整体排序，遍历整个数组，分别从两边的数组中获取最小的放到对应位置
        while (helpLeft <= middle && helpRight<= foot) {
            if ([desArr[helpLeft] integerValue] <= [desArr[helpRight] integerValue]) {
                srcArr[current] = desArr[helpLeft];
                helpLeft++;
            }else{
                srcArr[current] = desArr[helpRight];
                helpRight++;
            }
            current++;
        }
        //这个表示前面先排完，那么后面数组的大数肯定是合适的
        if (middle-helpLeft < 0) {
            return;
        }
        
        //表示前面那一个数组在排序中大于后面数组最大值剩余的个数，都添加到数组末尾去
        for (NSInteger i = 0; i <= (middle-helpLeft); i++) {
            srcArr[current+i] = desArr[helpLeft+i];
        }
    };
    
    //无限对半分割数组
    __block void(^MergeSortTwoArr)(NSMutableArray *srcArr,NSMutableArray *desArr,NSInteger head,NSInteger foot) = ^void(NSMutableArray *srcArr,NSMutableArray *desArr,NSInteger head,NSInteger foot){
        
        if (head < foot) {
            NSInteger middle = (foot - head)/2 + head;
            MergeSortTwoArr(srcArr, desArr, head, middle);
            MergeSortTwoArr(srcArr, desArr, middle+1, foot);
            SortArr(srcArr,desArr,head,foot,middle);
            
        }
    };
    
    MergeSortTwoArr(marr,hmarr,0,marr.count-1);
    NSLog(@"%@",marr);
    
}

//希尔排序
- (void)shellSort:(NSMutableArray *)arr{
    
    NSInteger gap = arr.count/2;
    
    //将大的数组，按间隔分成若干个小数组，先对小数组进行插入排序，最后整体排序
    while (1 <= gap) {
        
        for (NSInteger i = gap; i < arr.count; i++) {
            NSInteger j = i - gap;
            //需要排序的数
            NSInteger tmpValue = [arr[i] integerValue];
            //每次遍历完之后，就是从小到大的顺序位置，只要小，就把当前数字后移，这里就是tmpvalue的位置， j+gap 的位置就是tmpValue适合的位置，
            while (j >= 0 && tmpValue < [arr[j] integerValue]) {
                arr[j + gap] = arr[j];
                j -= gap;
            }
            arr[j+gap] = @(tmpValue);
        }
        gap /= 2;
    }
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
- (void)selectSort:(NSMutableArray *)marr{
    
    //有n个待排数字的数组
    //NSMutableArray *marr = [arr mutableCopy];
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
    //NSLog(@"%@",marr);
}

//选择排序--二元排序
- (void)selectSort2:(NSArray *)arr{
    
    //有n个待排数字的数组
    NSMutableArray *marr = [arr mutableCopy];
    //从寻找最小和最大数字的次数
    for (int i = 0; i < marr.count/2; i++) {
        NSInteger minIndex = i;
        NSInteger maxIndex = marr.count-i-1;
        for (int j = i; j < marr.count-i; j++) {
            //找到后面最小和最大元素下标
            NSInteger min = [marr[minIndex] integerValue];
            NSInteger max = [marr[maxIndex] integerValue];
            NSInteger current = [marr[j] integerValue];
            if (current < min) {
                minIndex = j;
                continue;
            }
            if (current > max) {
                maxIndex = j;
            }
        }
        //将最小和最大的元素放在对应位置
        [marr exchangeObjectAtIndex:minIndex withObjectAtIndex:i];
        [marr exchangeObjectAtIndex:maxIndex withObjectAtIndex:marr.count-i-1];
    }
    //NSLog(@"%@",marr);
}

//选择排序———堆排序
- (void)heapSort:(NSMutableArray *)marr{
    
    //第i个节点的父节点为(i-1)/2
    //左右子节点为(2*1)+1 、 (2*1)+2
    //二叉堆：父节点的键值总是大于，或小于任何一个子节点的键值，每一个左右子树也都是二叉堆
    
   //NSMutableArray *marr = [arr mutableCopy];
    
    NSInteger (^getChildLeftIndex)(NSInteger current) = ^NSInteger(NSInteger current){
        return 2*current+1;
    };
    NSInteger (^getChildRightIndex)(NSInteger current) = ^NSInteger(NSInteger current){
        return 2*current+2;
    };
    NSInteger (^getParentIndex)(NSInteger current) = ^NSInteger(NSInteger current){
        return (current-1)/2;
    };
    //构建一个最大堆（根节点值大于子节点值），比较当前节点的左右节点是否大于自身，如果大就交换，并别重排交换过后的子节点
    __block void(^MaxHeapBlock)(NSMutableArray *marr,NSInteger length,NSInteger current) = ^void(NSMutableArray *marr,NSInteger length,NSInteger current){
    
        NSInteger left = getChildLeftIndex(current);
        NSInteger right = getChildRightIndex(current);
        
        NSInteger largest = current;
        if (left<length && [marr[left] integerValue] > [marr[largest] integerValue]) {
            largest = left;
        }
        if (right<length && [marr[right] integerValue] > [marr[largest] integerValue]) {
            largest = right;
        }
        
        if (largest != current) {
            [marr exchangeObjectAtIndex:current withObjectAtIndex:largest];
            MaxHeapBlock(marr,length,largest);
        }
    };
    //其实是从子节点开始排，一直排到根节点,构建一个完整的最大堆
    for (NSInteger i = marr.count-1; i>=0; i--) {
        MaxHeapBlock(marr,marr.count,i);
    }
    
    //将根节点的数字放入数组最末尾，然后按照去掉一个末尾元素的数组重新构建一个最大堆
    for (NSInteger i = marr.count-1; i>0; i--) {
        [marr exchangeObjectAtIndex:i withObjectAtIndex:0];
        MaxHeapBlock(marr,i,0);
    }
    
}


//交换排序
- (void)exchangeSort:(NSArray *)arr{
    
    NSMutableArray *marr = [arr mutableCopy];
    //循环次数
    for (int i = 0; i < marr.count-1; i++) {
        //每次都从后面获取一个最小的与最前面的比较
        for (int j = i+1; j<marr.count; j++) {
            if ([marr[j] integerValue] < [marr[i] integerValue]) {
                [marr exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
        }
    }
    
}

//冒泡排序
- (void)popSort:(NSArray *)arr{
    
    NSMutableArray *marr = [arr mutableCopy];
    
    NSInteger exchangeCount = 0;
    NSInteger loopCount = 0;
    
    //排序次数
    for (int i = 0; i < marr.count; i++) {
        //从列表中第一个数字到最后一个没有拍好的数字
        for (int j = 0; j < marr.count-i-1; j++) {
            //如果前面的大于后面的，就交换
            NSInteger first = [marr[j] integerValue];
            NSInteger seconde = [marr[j+1] integerValue];
            if (first > seconde) {
                [marr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                exchangeCount++;
            }
            loopCount++;
        }
    }
    
    NSLog(@"冒泡 changeCount%zd   loopCount%zd",exchangeCount,loopCount);
}

//双向冒泡排序
- (void)bothWaySort:(NSArray *)arr{
    
    NSMutableArray *marr = [arr mutableCopy];
    
    NSInteger headIndex = 0;
    NSInteger footIndex = marr.count-1;
    
    NSInteger exchangeCount = 0;
    NSInteger loopCount = 0;
    
    //头尾相遇表示排序完成
    while (headIndex < footIndex) {
        
        //从后往前遍历,表示循环完了，最小的在最前面
        for (NSInteger i = footIndex; i > headIndex; i--) {
            if ([marr[i] integerValue] < [marr[i-1] integerValue]) {
                [marr exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                exchangeCount++;
            }
            loopCount++;
        }
        headIndex++;
        if (headIndex >= footIndex) {
            break;
        }
        //从前往后，将最大的放在最后面
        for (NSInteger j = headIndex; j<footIndex; j++) {
            if ([marr[j] integerValue] > [marr[j+1] integerValue]) {
                [marr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                exchangeCount++;
            }
            loopCount++;
        }
        footIndex--;
    }
    NSLog(@"双向 changeCount%zd   loopCount%zd",exchangeCount,loopCount);
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

//基数排序
- (void)baseSort:(NSArray *)arr Count:(NSInteger)count{
   
    NSInteger base = 1;//比较的位数
    NSMutableArray *srcMarr = [arr mutableCopy];
    NSMutableArray *marr = [NSMutableArray array];//放位数的二维数组
    
    /*
        先按照个位数排序，然后按照十位数排序，最后按照最高位排序
     */
    
    //最大的数的位数决定这层循环次数
    while (base<=count) {
        
        //为了取得对应位数上面的值
        NSInteger baseCount = 1;
        for (int i = 1; i < base; i++) {
            baseCount*=10;
        }
        //创建按照对应位数值的二维数组
        [marr removeAllObjects];
        for (int i = 0; i < 10; i++) {
            NSMutableArray *bitarr = [NSMutableArray array];
            [marr addObject:bitarr];
        }
        //根据位数值，放入对应二维数组
        for (NSNumber *value in srcMarr) {
            [marr[([value integerValue]/(baseCount))%10] addObject:value];
        }
        
        //直接拼接二维数组中的值
        [srcMarr removeAllObjects];
        for (NSArray *tmparr in marr) {
            [srcMarr addObjectsFromArray:tmparr];
        }
        base++;
    }
    NSLog(@"%@",srcMarr);
}


@end
