//
//  ViewController.m
//  CoreDataDemo
//
//  Created by runo on 17/1/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataDemo-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //传入模型对象，初始化NSPersistentStoreCoordinatior
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //构建sqlite数据库文件路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    //添加持久化存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        NSLog(@"error %@",error.localizedDescription);
    }
    
    //初始化上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
    context.persistentStoreCoordinator = psc;
    
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    [person setValue:@"CQ" forKey:@"name"];
    [person setValue:@(18) forKey:@"age"];
    [context save:nil];
    
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
//    NSArray *result = [context executeFetchRequest:request error:nil];
//   
//    NSLog(@"%@",[result valueForKey:@"name"]);
//    
//    Person *per = [result firstObject];
//    NSLog(@"per %@",per.name);
    
}

















@end
