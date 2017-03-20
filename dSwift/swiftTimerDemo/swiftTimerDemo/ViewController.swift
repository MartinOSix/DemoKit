//
//  ViewController.swift
//  swiftTimerDemo
//
//  Created by runo on 17/3/15.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var labelView: UILabel?
    var startBtn: UIButton?
    var stopBtn: UIButton?
    var clickTimer: Timer?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        labelView = UILabel.init(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight*0.7))
        labelView?.backgroundColor = UIColor.white
        labelView?.textAlignment = .center
        labelView?.textColor = UIColor.black
        labelView?.font = UIFont.systemFont(ofSize: 33)
        labelView?.text = "\(count)"
        view.addSubview(labelView!)
        
        startBtn = UIButton(type: .custom)
        startBtn?.frame = CGRect(x: 0, y: KScreenHeight*0.7, width: KScreenWidth*0.5, height: KScreenHeight*0.3)
        startBtn?.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        startBtn?.setTitle("start", for: .normal)
        startBtn?.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(startBtn!)
        
        stopBtn = UIButton(type: .custom)
        stopBtn?.frame = CGRect(x: KScreenWidth*0.5, y: KScreenHeight*0.7, width: KScreenWidth*0.5, height: KScreenHeight*0.3)
        stopBtn?.addTarget(self, action: #selector(stopBtnClick), for: .touchUpInside)
        stopBtn?.setTitleColor(UIColor.black, for: .normal)
        stopBtn?.setTitle("reset", for: .normal)
        view.addSubview(stopBtn!)
        
        clickTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.count += 1
            self.labelView?.text = "\(self.count)"
            print("click")
        })
        
        
    }

    func startBtnClick() {
        
        if self.clickTimer != nil {
    
        }else{
            self.clickTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (tim) in
                self.count += 1
                self.labelView?.text = "\(self.count)"
                print("click")
            })
        }
        
    }
    
    //reset
    func stopBtnClick() {
        
        self.clickTimer?.invalidate()
        self.count = 0
        self.labelView?.text = "0"
        self.clickTimer = nil
        
    }

}

