//
//  HomeItemModel.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class HomeItemModel: NSObject {

    var editable: Bool?
    var id: Int?
    var name: String?
    
    init(dict: [String: AnyObject]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        editable = dict["editable"] as? Bool
    }
    
}
