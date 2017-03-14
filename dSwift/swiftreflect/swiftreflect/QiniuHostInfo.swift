//
//  QiniuHostInfo.swift
//  swiftreflect
//
//  Created by runo on 17/3/14.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

final class QiniuHostInfo: NSObject, NSCoding {

    var name = ""
    var accessKey = ""
    var secretKey = ""
    
    init(name: String, accessKey: String, secretKey: String) {
        self.name = name
        self.accessKey = accessKey
        self.secretKey = secretKey
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: #keyPath(name)) as! String
        accessKey = aDecoder.decodeObject(forKey: #keyPath(accessKey)) as! String
        secretKey = aDecoder.decodeObject(forKey: #keyPath(secretKey)) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: #keyPath(name))
        aCoder.encode(accessKey, forKey: #keyPath(accessKey))
        aCoder.encode(secretKey, forKey: #keyPath(secretKey))
    }
    
}
















