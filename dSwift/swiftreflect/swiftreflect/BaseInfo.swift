//
//  BaseInfo.swift
//  swiftreflect
//
//  Created by runo on 17/3/15.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class BaseInfo: NSObject, NSCoding {
    
    var name = ""
    
    override init() {
        super.init()
    }
    
    convenience required init(coder aDecoder:NSCoder) {
        self.init()
        
        forEachChildOfMirror(reflecting: self) { (key) in
            setValue(aDecoder.decodeObject(forKey: key), forKey: key)
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        forEachChildOfMirror(reflecting: self) { (key) in
            aCoder.encode(value(forKey: key), forKey: key)
        }
        
    }
    
    func forEachChildOfMirror(reflecting subject: Any, handler:(String)->Void) {
        
        var mirror: Mirror? = Mirror(reflecting: subject);
        while mirror != nil {
            print("style \(mirror!.displayStyle!)")
            print("type \(mirror!.subjectType)")
            for child in mirror!.children {
                
                if let key = child.label {
                    print("property \(key) \(child.value) \(child)")
                    handler(key)
                }
            }
            mirror = mirror!.superclassMirror
        }
    }
    
}

final class TestA: BaseInfo{
    var accessKey = ""
    var secretKey = ""
}

final class TestB: BaseInfo{
    var userName = ""
    var password = ""
}
