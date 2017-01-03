//
//  NSObject_SharInstance.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit
//单例
class NSObject_SharInstance {
    static let sharInstance = NSObject_SharInstance()
    private init(){
    }
}
