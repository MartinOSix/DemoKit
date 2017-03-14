//
//  AccessoryViews.swift
//  2048swift
//
//  Created by runo on 17/3/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import Foundation
import UIKit

//方便别的类中调用计分板的scoreChanged
protocol ScoreViewProtocol {
    func scoreChange(to s: Int)
}

class ScoreView : UIView,ScoreViewProtocol {
    
    let defaultFrame = CGRect(x: 0, y: 0, width: 140, height: 40)
    var label: UILabel
    var score : Int = 0 {
        didSet {
            label.text = "SCORE: \(score)"
        }
    }
    
    init(backgroundColor bgcolor:UIColor, textColor tcolor: UIColor, font: UIFont, radius r: CGFloat){
        label = UILabel(frame: defaultFrame)
        label.textAlignment = NSTextAlignment.center
        super.init(frame: defaultFrame)
        backgroundColor = bgcolor
        label.textColor = tcolor
        label.font = font
        layer.cornerRadius = r
        self.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func scoreChange(to s: Int) {
        score = s
    }
    
}

class ControlView {
    let defaultFrame = CGRect(x: 0, y: 0, width: 140, height: 40)
}





















