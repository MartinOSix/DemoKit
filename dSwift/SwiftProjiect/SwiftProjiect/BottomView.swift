//
//  BottomView.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class BottomView: UIScrollView {
    
    var contentVCs: [UIViewController]? = nil
    var currentIndex: Int = 0
    
    init(frame: CGRect,viewControllers :[UIViewController]) {
        
        super.init(frame: frame)
        self.contentVCs = viewControllers
        if self.contentVCs?.count == 0 {
            return
        }
        self.contentSize = CGSize.init(width: frame.size.width * CGFloat((self.contentVCs?.count)!), height: frame.height)
        self.bounces = false
        self.isPagingEnabled = true
        setUpContentVC()
    }
    
    func setUpContentVC() {
        
        let currentVC = self.contentVCs?[self.currentIndex]
        if self.contentVCs?.count == 1 {
            self.contentSize = self.frame.size
            self.addSubview((currentVC?.view)!)
            return
        }else if self.contentVCs?.count == 2 {
            self.contentSize = CGSize.init(width: frame.size.width * 2.0, height: frame.height)
        }else{
            self.contentSize = CGSize.init(width: frame.size.width * 3, height: frame.height)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
