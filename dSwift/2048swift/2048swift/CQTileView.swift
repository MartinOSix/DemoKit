//
//  CQTileView.swift
//  2048swift
//
//  Created by runo on 17/3/14.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

enum TileValueEnum{
    case EMPTY
    case VALUE(Int)
    
    func getValue() -> Int {
        switch self {
        case .EMPTY:
            return 0
        case let .VALUE(a):
            return a
        default:
            break;
        }
    }
}

class CQTileView: UIView {

    var titleLabel : UILabel!
    var value :TileValueEnum = .EMPTY{
        didSet{
            
        switch value {
            case .EMPTY:
                titleLabel.text = ""
            case let .VALUE(a):
                titleLabel.text = "\(a)"
            }
            
        }
    }
    
    init(frame: CGRect, Value v: TileValueEnum) {
        
        self.titleLabel = UILabel(frame:CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.titleLabel.backgroundColor = UIColor.black
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = NSTextAlignment.center
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.value = v
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
