
//
//  UIColorCategory.swift
//  SwiftDemoKit
//
//  Created by runo on 17/7/7.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let randomR = (CGFloat(arc4random()%255) / 255.0) as CGFloat
        let randomG = (CGFloat(arc4random()%255) / 255.0) as CGFloat
        let randomB = (CGFloat(arc4random()%255) / 255.0) as CGFloat
        
        return UIColor.init(red: randomR, green: randomG, blue: randomB, alpha: 1)
        
    }
    
}
