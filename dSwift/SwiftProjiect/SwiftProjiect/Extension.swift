//
//  Extension.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// x
    var cq_x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var cq_y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var cq_width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var cq_size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
}

extension UIColor {
    static func arcColor() -> UIColor {
        
        let arcR = CGFloat.init(arc4random()%255)/255.0
        let arcB = CGFloat.init(arc4random()%255)/255.0
        let arcG = CGFloat.init(arc4random()%255)/255.0
        let uicolor = UIColor.init(red: arcR, green: arcB, blue: arcG, alpha: 1.0)
        return uicolor
    }
}


