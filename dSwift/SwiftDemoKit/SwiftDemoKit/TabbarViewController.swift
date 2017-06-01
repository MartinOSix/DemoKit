//
//  TabbarViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewa = TabAViewController()
        viewa.title = "viewA"
        let bg = UIImageView(frame: kScreenBounds)
        bg.image = #imageLiteral(resourceName: "dudu")
        viewa.view.addSubview(bg)
        viewa.tabBarItem.title = "A"
        
        
        let viewb = TabBViewController()
        viewb.title = "viewB"
        let bgb = UIImageView(frame: kScreenBounds)
        bgb.image = #imageLiteral(resourceName: "hello")
        viewb.view.addSubview(bgb)
        viewb.tabBarItem.title = "B"
        //viewb.tabBarItem.image = #imageLiteral(resourceName: "hello")
        
        let viewc = TabCViewController()
        viewc.title = "viewC"
        let bgc = UIImageView(frame: kScreenBounds)
        bgc.image = #imageLiteral(resourceName: "bodyline")
        viewc.view.addSubview(bgc)
        viewc.tabBarItem.title = "C"
        //viewc.tabBarItem.image = #imageLiteral(resourceName: "bodyline")
        
        self.viewControllers = [viewa,viewb,viewc]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
