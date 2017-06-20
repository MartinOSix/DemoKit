//
//  Person+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Dog *> *dogMaster;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addDogMasterObject:(Dog *)value;
- (void)removeDogMasterObject:(Dog *)value;
- (void)addDogMaster:(NSSet<Dog *> *)values;
- (void)removeDogMaster:(NSSet<Dog *> *)values;

@end

NS_ASSUME_NONNULL_END
