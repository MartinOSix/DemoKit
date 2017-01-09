//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by runo on 17/1/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var gendar: String?
    @NSManaged public var card: Card?

}
