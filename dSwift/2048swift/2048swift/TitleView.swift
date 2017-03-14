//
//  TitleView.swift
//  2048swift
//
//  Created by runo on 17/3/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    //数字块中的值
    var value : Int = 0 {
        didSet {
            backgroundColor = delegate.titleColor(value)
            numberLabel.textColor = delegate.numberColor(value)
            numberLabel.text = "\(value)"
        }
    }
    //颜色选择
    unowned let delegate : AppearanceProviderProtocol
    //数字块
    let numberLabel : UILabel
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    //初始化
    init(position: CGPoint, width: CGFloat, value: Int, radius: CGFloat, delegate d:AppearanceProviderProtocol) {
        delegate = d
        numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        numberLabel.textAlignment = NSTextAlignment.center
        numberLabel.minimumScaleFactor = 0.5
        numberLabel.font = delegate.fontForNumbers()
        
        super.init(frame: CGRect(x: position.x, y: position.y, width: width, height: width))
        addSubview(numberLabel)
        layer.cornerRadius = radius
        
        self.value = value
        backgroundColor = delegate.titleColor(value)
        numberLabel.textColor = delegate.numberColor(value)
        numberLabel.text = "\(value)"

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
