//
//  ViewController.swift
//  2048swift
//
//  Created by runo on 17/3/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var startBtn : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startBtn = UIButton.init(type: .custom)
        
        self.startBtn!.addTarget(self,  action: #selector(startBtnClick), for: .touchUpInside);
        self.startBtn!.addTarget(self, action: #selector(startBtnClick), for: .touchDown);
        self.startBtn!.frame = CGRect.init(x: 100, y: 100, width: 100, height: 30);
        self.startBtn!.setTitle("BTN", for: .normal);
        self.startBtn!.backgroundColor = UIColor.orange;
        self.view.addSubview(self.startBtn!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func startBtnClick() {
        print("hahaha")
    }
    
}

