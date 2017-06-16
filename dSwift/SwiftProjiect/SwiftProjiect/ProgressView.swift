//
//  ProgressView.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/15.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    private var trueProgress: CGFloat = 0.0
    var progress: CGFloat {
        
        get{
            return trueProgress
        }
        
        set(newValue){
            trueProgress = newValue
            //手动调用刷新方法
            self.setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        let radius = rect.size.width/2 - 3
        let center = CGPoint.init(x: radius, y: radius)
        let startAngle = -M_PI_2
        let endAngle = -M_PI_2 + 2 * M_PI * Double.init(self.trueProgress)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        path.lineWidth = 5
        path.stroke()
    }


}
