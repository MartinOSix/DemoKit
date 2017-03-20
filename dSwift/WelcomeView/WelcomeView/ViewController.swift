//
//  ViewController.swift
//  WelcomeView
//
//  Created by runo on 17/3/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController, UIScrollViewDelegate {

    
    var scrollview: UIScrollView?
    let pagecontrol = UIPageControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        
        self.scrollview = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.scrollview?.contentSize = CGSize(width: kScreenWidth*3, height: kScreenHeight)
        self.view .addSubview(self.scrollview!)
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        view1.backgroundColor = UIColor.red
        self.scrollview?.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight))
        view2.backgroundColor = UIColor.blue
        self.scrollview?.addSubview(view2)
        
        let view3 = UIView(frame: CGRect(x: kScreenWidth*2, y: 0, width: kScreenWidth, height: kScreenHeight))
        view3.backgroundColor = .orange
        self.scrollview?.addSubview(view3)
        
        self.scrollview?.isPagingEnabled = true
        self.scrollview?.delegate = self
        self.scrollview?.showsHorizontalScrollIndicator = false
        
        pagecontrol.frame = CGRect(x: 0, y: kScreenHeight-20, width: kScreenWidth, height: 20)
        pagecontrol.backgroundColor = .clear
        pagecontrol.numberOfPages = 3
        pagecontrol.pageIndicatorTintColor = .gray
        pagecontrol.currentPageIndicatorTintColor = .orange
        pagecontrol.isUserInteractionEnabled = false
        self.view?.addSubview(pagecontrol)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int((scrollview?.contentOffset.x)! / kScreenWidth)
        pagecontrol.currentPage = index
        
    }

    
}

