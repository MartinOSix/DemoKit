//
//  ViewController.m
//  CoreDataDemo
//
//  Created by runo on 17/6/5.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "Dog+CoreDataClass.h"
#import "Person+CoreDataClass.h"
#import "AppDelegate.h"
@interface CustomView : UIScrollView<UIGestureRecognizerDelegate>

@end

@interface ViewController ()

@property(nonatomic,readonly) AppDelegate *appDelegate;
@property(nonatomic,assign) NSInteger count;
@property(nonatomic,strong) NSMutableArray *dataSource;

-(ViewController * (^)(int i))add;
-(ViewController *)setaddInteger:(int)i;
-(NSString *)print;

@end

@implementation ViewController

-(AppDelegate *)appDelegate{
    return  ((AppDelegate *)[UIApplication sharedApplication].delegate);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    NSString *str = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"-- %@,%f",str, ceil(2.5));
    int a = 10,b = 20;
    int *p = &a;
    *p = 20;
    printf("%d %d \n",a,*p);
    
    CustomView *cview =[[CustomView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    cview.backgroundColor = [UIColor redColor];
    [self.view addSubview:cview];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSMutableArray *marr2 = [mutableArray mutableCopy];
    int it = 1;
    
    /*
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    Person *perosn = [[Person alloc]initWithEntity:entity insertIntoManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    perosn.name = @"name";
    perosn.age = 18;
    [self.appDelegate saveContext];
    [self.dataSource addObject:perosn];
    */
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *arr = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Person *p = (Person *)obj;
        p.name = [NSString stringWithFormat:@"name_%d",idx];
        p.age = idx;
        
    }];
    [self.appDelegate saveContext];
    
    arr = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    for (Person *p  in arr) {
        NSLog(@"person.name = %@  age = %d  dog = %@",p.name,p.age,p.dogMaster);
    }
    NSLog(@"%d",self.count);
    NSPredicate *per = [[NSPredicate alloc]init];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"vc touch began");
}

-(ViewController * (^)(int i))add{
    
    return ^(int a){
        self.count += a;
        return self;
    };
}

-(NSString *)print{
    NSLog(@"print");
    return nil;
}

-(ViewController *)setaddInteger:(int)i{
    self.count += i;
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@implementation CustomView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"customer view touch began");
    [self.nextResponder touchesBegan:touches withEvent:event];
}




@end
