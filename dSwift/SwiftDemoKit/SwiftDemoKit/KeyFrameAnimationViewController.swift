//
//  KeyFrameAnimationViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class KeyFrameAnimationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight/2), style: .plain)
    let dataSource = ["位置关键帧","路径关键帧","PositionX","动画组"]
    
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
            keyFrameAnimation()
        case 1:
            keyFrameAnimationPath()
        case 2:
            keyFramePositionX()
        case 3:
            groupAnimation()
        default:
            break
        }
    }
    
    func keyFrameAnimation() {
        
        let animation = CAKeyframeAnimation()
        
        animation.keyPath = "position";
        
        let value1 =  NSValue.init(cgPoint: CGPoint.init(x: 50, y: 50))
        let value2 =  NSValue.init(cgPoint: CGPoint.init(x: kScreenWidth-100, y: 50))
        let value3 =  NSValue.init(cgPoint: CGPoint.init(x: kScreenWidth-100, y: kScreenHeight-50))
        let value4 =  NSValue.init(cgPoint: CGPoint.init(x: 50, y: kScreenHeight-50))
        let value5 =  NSValue.init(cgPoint: CGPoint.init(x: 50, y: 50))
        
        animation.values = [value1,value2,value3,value4,value5]
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards;
        animation.duration = 6.0;
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.showView.layer.add(animation, forKey: "keyframe")
    }

    func keyFrameAnimationPath() {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        let path = CGMutablePath();
        
        //矩形线路
        path.addEllipse(in: kScreenBounds)
        animation.path=path;
        animation.repeatCount = MAXFLOAT;
        animation.isRemovedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards;
        animation.duration = 5;
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.showView.layer.add(animation, forKey: "keyframe")
    }
    
    func keyFramePositionX() {
        let animation = CAKeyframeAnimation();
        
        animation.keyPath = "position.x";
        animation.values = [50,150,200,210,0]
            //[NSNumber.init(value: 100),NSNumber.init(value: 150),NSNumber.init(value: 125),NSNumber.init(value: 170),NSNumber.init(value: 0)];
        animation.keyTimes = [NSNumber.init(value: 0),NSNumber.init(value: 1/6),NSNumber.init(value: 3/6),NSNumber.init(value: 4/6),NSNumber.init(value: 1)];
        animation.duration = 6;
        animation.isAdditive = true;
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.showView.layer.add(animation, forKey: "keyframe")
    }
    
    func groupAnimation() {
        
        let animationScale = CABasicAnimation()
        animationScale.keyPath = "transform.scale";
        animationScale.toValue = NSNumber.init(value: 0.1)
        
        let animationRota = CABasicAnimation()
        animationRota.keyPath = "transform.rotation";
        animationRota.toValue = NSNumber.init(value: M_PI_2)
        
        let group = CAAnimationGroup()
        group.duration = 3.0;
        group.fillMode = kCAFillModeForwards;
        group.isRemovedOnCompletion = false;
        group.repeatCount = MAXFLOAT;
        
        group.animations = [animationScale,animationRota];
        self.showView.layer.add(group, forKey: "group")
    }
    
    
}
