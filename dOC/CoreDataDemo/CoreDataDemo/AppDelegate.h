//
//  AppDelegate.h
//  CoreDataDemo
//
//  Created by runo on 17/6/5.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

