//
//  ChannelTitleView.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import Foundation

public protocol ChannelTitleViewDelegate: NSObjectProtocol {
    
    func channelTitleView(DidSelect Index:Int)
    
}

class ChannelTitleView: UIScrollView {
    
    
    var titles: [String]?
    var currentIndex: Int = 0
    var buttonArr = [UIButton]()
    var titleNormalColor = UIColor.black
    var titleSelecColor = UIColor.red
    var titleFont : CGFloat = 14.0
    var indicateView = UIView()
    weak open var clickDelegate: ChannelTitleViewDelegate?
    
    
    init(frame: CGRect,titles :[String]) {
        super.init(frame: frame)
        
        if titles.count == 0 {
            return
        }
        
        setUpTitleView(titles: titles)
        setUpIndicateView()
    }
    
    func setUpIndicateView() {
        indicateView.backgroundColor = UIColor.red
        let btn = self.buttonArr[self.currentIndex]
        indicateView.frame = CGRect(x: btn.cq_x, y: frame.height-3, width: btn.cq_width, height: 3)
        self.addSubview(indicateView)
    }
    
    func setUpTitleView(titles: [String]) {
        
        //移除原始数据
        buttonArr.removeAll()
        for (_,value) in self.subviews.enumerated() {
            value.removeFromSuperview()
        }
        
        var upBtnFrameMaxY: CGFloat = 0
        for title in titles {
            
            let btn = UIButton(type: UIButtonType.custom)
            let nsTitle = NSString.init(string: title)
            let btnSize = nsTitle.boundingRect(with: CGSize.init(width: 0, height: frame.size.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: self.titleFont)], context: nil)
            
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(self.titleNormalColor, for: .normal)
            btn.setTitleColor(self.titleSelecColor, for: .selected)
            btn.setTitleColor(self.titleNormalColor, for: .focused)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleFont)
            btn.frame = CGRect.init(x: upBtnFrameMaxY, y: 0.0, width: btnSize.width+10, height: frame.size.height)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            
            
            upBtnFrameMaxY = btn.frame.maxX
            self.addSubview(btn)
            buttonArr.append(btn)
            
            self.contentSize = CGSize(width: btn.frame.maxX, height: frame.size.height)
            self.showsHorizontalScrollIndicator = false
            self.bounces = false
        }
        
        let btn = self.buttonArr[self.currentIndex]
        btn.isSelected = true
        
        //如果没有超过一页则平铺
        if upBtnFrameMaxY < kScreenWidth {
            resetBntFrame(totalWidth: upBtnFrameMaxY)
        }
        
    }
    
    //按比例平铺Btn
    func resetBntFrame(totalWidth: CGFloat) {
        
        var upBtnFrameMaxX: CGFloat = 0
        for btn in self.buttonArr {
            let newWidth = btn.frame.width/totalWidth * kScreenWidth
            btn.cq_width = newWidth
            btn.cq_x = upBtnFrameMaxX;
            upBtnFrameMaxX = btn.frame.maxX
        }
    }
    
    //btn点击事件
    func btnClick(btn :UIButton) {
        
        if let index = self.buttonArr.index(of: btn),index != self.currentIndex {
            
            let previousBtn = self.buttonArr[self.currentIndex]
            previousBtn.isSelected = false
            btn.isSelected = true
            self.currentIndex = index
            
            let frame = CGRect(x: btn.cq_x, y: self.frame.height-3, width: btn.cq_width, height: 3)
            UIView.animate(withDuration: 0.2, animations: {
                self.indicateView.frame = frame
            })
            self.clickDelegate?.channelTitleView(DidSelect: index)
        }
    }
    
    func rsetCurrentIndex(At index:Int) {
        
        let btn = self.buttonArr[index]
        btn.sendActions(for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
