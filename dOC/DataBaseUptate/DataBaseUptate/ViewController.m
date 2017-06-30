//
//  ViewController.m
//  DataBaseUptate
//
//  Created by runo on 17/6/30.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import <FMDB/FMDB.h>
#import <FMDBMigrationManager/FMDBMigrationManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *DBPath = NSHomeDirectory();
    DBPath = [DBPath stringByAppendingPathComponent:@"Documents/TableDataBase.db"];
    FMDBMigrationManager * manager=[FMDBMigrationManager managerWithDatabaseAtPath:DBPath migrationsBundle:[NSBundle mainBundle]];
    NSLog(NSHomeDirectory());
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }
    
    //升级到最高版本
    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    NSLog(@"%llu",[manager currentVersion]);
    
}



@end
