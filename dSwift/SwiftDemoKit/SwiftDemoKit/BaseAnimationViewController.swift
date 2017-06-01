//
//  BaseAnimationViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/26.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class BaseAnimationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight/2), style: .plain)
    let dataSource = ["呼吸灯/透明度","摇摆","打开钉钉"]
    
    let showView = UIView.init(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.showView.frame = CGRect.init(x: 100, y: kScreenHeight/2+100, width: 50, height: 50)
        self.showView.backgroundColor = UIColor.red
        self.view.addSubview(self.showView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            baseAnimationOpacity()
        case 1:
            baseAnimationRotationZ()
        default:
            if UIApplication.shared.canOpenURL(URL.init(string: "dingtalk-open://")!){
                UIApplication.shared.openURL(URL.init(string: "dingtalk-open://")!)
            }
            break
        }
    }

    func baseAnimationOpacity() {
        
        let baseAnimation = CABasicAnimation.init(keyPath: "opacity")
        baseAnimation.fromValue = NSNumber.init(value: 1.0)
        baseAnimation.toValue = NSNumber.init(value: 0.0)
        baseAnimation.autoreverses = true//动画可以逆向回去
        baseAnimation.duration = 1.0
        baseAnimation.repeatCount = MAXFLOAT
        baseAnimation.isRemovedOnCompletion = false
        baseAnimation.fillMode = kCAFillModeForwards
        baseAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        self.showView.layer.add(baseAnimation, forKey: "alpha")
        
    }
    
    func baseAnimationRotationZ() {
        self.showView.layer.position = CGPoint.init(x: self.showView.frame.midX, y: self.showView.frame.minY)
        self.showView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        let baseAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        baseAnimation.fromValue = NSNumber.init(value: 0)
        baseAnimation.toValue = NSNumber.init(value: 1)
        baseAnimation.duration = 1.0
        baseAnimation.repeatCount = MAXFLOAT
        baseAnimation.isRemovedOnCompletion = false
        baseAnimation.autoreverses = true
        baseAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        baseAnimation.fillMode = kCAFillModeForwards
        self.showView.layer.add(baseAnimation, forKey: "Rotating")
    }

}














