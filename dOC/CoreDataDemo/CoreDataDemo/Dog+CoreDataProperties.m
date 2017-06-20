//
//  Dog+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by runo on 17/6/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "Dog+CoreDataProperties.h"

@implementation Dog (CoreDataProperties)

+ (NSFetchRequest<Dog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Dog"];
}

@dynamic name;
@dynamic color;
@dynamic master;

@end
