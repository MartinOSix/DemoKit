//
//  CompositePatternViewController.m
//  DesignModel
//
//  Created by runo on 17/2/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "CompositePatternViewController.h"

@interface Corp : NSObject
@end
@implementation Corp{
    NSString *_name;
    NSString *_position;
    int _salary;
}
-(instancetype)initWith:(NSString *)name Poi:(NSString *)position Salary:(int)salary{
    if (self = [super init]) {
        _name = name;
        _position = position;
        _salary = salary;
    }
    return self;
}
-(NSString *)getInfo{
    NSString *str = [NSString stringWithFormat:@"姓名:%@ \t职位:%@ \t薪水:%d",_name,_position,_salary];
    return str;
}
@end

@interface Leaf : Corp
@end
@implementation Leaf
-(instancetype)initLeafName:(NSString *)name Poi:(NSString *)position Salary:(int)salary{
    
    return [super initWith:name Poi:position Salary:salary];
}
@end

@interface Branch : Corp
@end
@implementation Branch{
    NSMutableArray<Corp *> * subordinateList;
}

-(instancetype)initBrachName:(NSString *)name Poi:(NSString *)position Salary:(int)salary{
    self = [super initWith:name Poi:position Salary:salary];
    subordinateList = [NSMutableArray array];
    return self;
}
-(void)addSubordinate:(Corp *)corp{
    [subordinateList addObject:corp];
}
-(NSArray<Corp *> *)getSubordinate{
    return [subordinateList copy];
}
@end


@interface CompositePatternViewController ()
@end
@implementation CompositePatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(Branch *)compositeCorpTree{
    
    Branch *root = [[Branch alloc]initWith:@"wangdamazi" Poi:@"ceo" Salary:100000];
    
    Branch *developDep = [[Branch alloc]initWith:@"liudaquezi" Poi:@"DevelopManager" Salary:10000];
    Branch *salesDep = [[Branch alloc]initWith:@"maergauizi" Poi:@"salesManager" Salary:20000];
    Branch *financeDep = [[Branch alloc]initWith:@"zhaosantuozi" Poi:@"finaceManager" Salary:30000];
    
    Branch *firstDevGroup = [[Branch alloc]initBrachName:@"yangsan" Poi:@"oneGroupLeader" Salary:5000];
    Branch *secondDevGroup = [[Branch alloc]initBrachName:@"wuda" Poi:@"twoGroupLeader" Salary:6000];
    
    Leaf *a = [[Leaf alloc]initLeafName:@"a" Poi:@"dr" Salary:200];
    Leaf *b = [[Leaf alloc]initLeafName:@"b" Poi:@"dr" Salary:200];
    Leaf *c = [[Leaf alloc]initLeafName:@"c" Poi:@"dr" Salary:200];
    Leaf *d = [[Leaf alloc]initLeafName:@"d" Poi:@"dr" Salary:200];
    Leaf *e = [[Leaf alloc]initLeafName:@"e" Poi:@"dr" Salary:200];
    Leaf *f = [[Leaf alloc]initLeafName:@"f" Poi:@"dr" Salary:200];
    Leaf *g = [[Leaf alloc]initLeafName:@"g" Poi:@"dr" Salary:200];
    Leaf *h = [[Leaf alloc]initLeafName:@"h" Poi:@"dr" Salary:200];
    Leaf *i = [[Leaf alloc]initLeafName:@"i" Poi:@"dr" Salary:200];
    Leaf *j = [[Leaf alloc]initLeafName:@"j" Poi:@"dr" Salary:200];
    Leaf *k = [[Leaf alloc]initLeafName:@"k" Poi:@"dr" Salary:200];
    
    Leaf *six = [[Leaf alloc]initLeafName:@"six" Poi:@"devManager" Salary:2000];
    
    [root addSubordinate:developDep];
    [root addSubordinate:salesDep];
    [root addSubordinate:financeDep];
    
    [developDep addSubordinate:six];
    
    return root;
}

@end










