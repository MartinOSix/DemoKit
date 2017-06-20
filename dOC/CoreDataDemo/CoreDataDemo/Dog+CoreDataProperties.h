//
//  Dog+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "Dog+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Dog (CoreDataProperties)

+ (NSFetchRequest<Dog *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *color;
@property (nullable, nonatomic, retain) Person *master;

@end

NS_ASSUME_NONNULL_END
