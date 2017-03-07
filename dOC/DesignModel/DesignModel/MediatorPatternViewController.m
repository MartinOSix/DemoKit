//
//  MediatorPatternViewController.m
//  DesignModel
//
//  Created by runo on 17/2/21.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "MediatorPatternViewController.h"

@class Purchase,Sale,Stock,AbstractColleague,AbstractMediator;

@interface AbstractColleague : NSObject
@property(nonatomic,strong)AbstractMediator     *mediator;
@end

@interface Purchase : AbstractColleague
@end

@interface Stock : AbstractColleague
@end

@interface Sale : AbstractColleague
@end

@interface AbstractMediator : NSObject

@property(nonatomic,strong) Purchase    *purchase;
@property(nonatomic,strong) Sale        *sale;
@property(nonatomic,strong) Stock       *stock;
-(void)execute:(NSString *)str Objects:(NSArray *)objects;
@end

@interface Mediator : AbstractMediator
@end


@implementation AbstractColleague

-(instancetype)initWith:(AbstractMediator *)media{
    self = [super init];
    if (self) {
        self.mediator = media;
    }
    return self;
}
@end

@implementation AbstractMediator

-(instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)execute:(NSString *)str Objects:(NSArray *)objects{
    [NSException raise:@"exception" format:@""];
}
@end


@implementation Purchase

-(instancetype)initWith:(AbstractMediator *)media{
    self = [super initWith:media];
    if (self) {
        media.purchase = self;
    }
    return self;
}

-(void)buyIBMcomputer:(int )number{
    [self.mediator execute:@"purchase.buy" Objects:@[@(number)]];
}
-(void)refuseBuyIBM{
    NSLog(@"不再采购IBM电脑");
}
@end



@implementation Stock

-(instancetype)initWith:(AbstractMediator *)media{
    self = [super initWith:media];
    if (self) {
        media.stock = self;
    }
    return self;
}

+(int)getComputerNumber{
    return *[self innerGetComputerNumber];
}

+(int *)innerGetComputerNumber{
    static int i = 100;
    return &i;
}

+(void)setComputerNumber:(int)num{
    *[self innerGetComputerNumber] = num;
}

-(void)increase:(int )num{
    [Stock setComputerNumber:[Stock getComputerNumber]+num];
    NSLog(@"库存数量为 %d",[Stock getComputerNumber]);
}

-(void)decrease:(int )number{
    [Stock setComputerNumber:[Stock getComputerNumber]-number];
    NSLog(@"库存数量为 %d",[Stock getComputerNumber]);
}

-(void)clearStock{
    NSLog(@"清理存货数量");
    [self.mediator execute:@"stock.clear" Objects:nil];
}
@end



@implementation Sale

-(instancetype)initWith:(AbstractMediator *)media{
    self = [super initWith:media];
    if (self) {
        media.sale = self;
    }
    return self;
}

-(void)sellIBMComputer:(int)number{
    [self.mediator execute:@"sale.sell" Objects:@[@(number)]];
    NSLog(@"销售IBM电脑%d台",number);
}

-(int )getSaleStatus{
    int a = arc4random()%100;
    NSLog(@"IBM电脑的销售情况为：%d",a);
    return a;
}

-(void)offSale{
    [self.mediator execute:@"sale.offsell" Objects:nil];
}

@end

@implementation Mediator

-(void)execute:(NSString *)str Objects:(NSArray *)objects{
    if ([str isEqualToString:@"purchase.buy"]) {
        [self buyComputer:[[objects firstObject] intValue]];
    }else if ([str isEqualToString:@"sale.sell"]){
        [self sellComputer:[[objects firstObject] intValue]];
    }else if ([str isEqualToString:@"sale.offsell"]){
        [self offSell];
    }else if ([str isEqualToString:@"sale.offsell"]){
        [self clearStock];
    }
}

-(void)buyComputer:(int )number{
    int saleStatus = [self.sale getSaleStatus];
    if (saleStatus > 80) {
        NSLog(@"采购IBM电脑%d台",number);
        [self.stock increase:number];
    }else{
        number = number/2;
        NSLog(@"采购IBM电脑%d台",number);
        [self.stock increase:number];
    }
}

-(void)sellComputer:(int)number{
    if ([Stock getComputerNumber] < number) {
        [self.purchase buyIBMcomputer:number];
    }
    [self.stock decrease:number];
}

-(void)offSell{
    NSLog(@"折价销售IBM电脑%d台",[Stock getComputerNumber]);
}

-(void)clearStock{
    [self.sale offSale];
    [self.purchase refuseBuyIBM];
}

@end

@interface MediatorPatternViewController ()
@end

@implementation MediatorPatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AbstractMediator *mediator = [[Mediator alloc]init];
    
    Purchase *purchase = [[Purchase alloc]initWith:mediator];
    Sale *sale = [[Sale alloc]initWith:mediator];
    Stock *stock = [[Stock alloc]initWith:mediator];
    
    NSLog(@"采购人员采购电脑");
    [purchase buyIBMcomputer:100];
    
    NSLog(@"销售人员销售电脑");
    [sale sellIBMComputer:1];
    
    NSLog(@"清理库存");
    [stock clearStock];
 
    NSLog(@"---");
}

@end
