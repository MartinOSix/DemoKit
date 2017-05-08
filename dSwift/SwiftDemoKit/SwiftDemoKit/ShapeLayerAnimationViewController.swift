//
//  ShapeLayerAnimationViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ShapeLayerAnimationViewController: UIViewController, CAAnimationDelegate {

    
    let centerX: Double = Double(kScreenWidth/2)
    let centerY: Double = Double(kScreenHeight/4)
    
    private let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .init(rawValue: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.white
        setUpView()
    }
    
    func setUpView() {
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 80.0
        shapeLayer.lineCap = "butt"//线条风格
        shapeLayer.lineJoin = "round"
        shapeLayer.strokeColor = UIColor.init(white: 0, alpha: 0.3).cgColor
            //UIColor.clear.cgColor
        view.layer.addSublayer(shapeLayer)
        
        let path = UIBezierPath(arcCenter: CGPoint.init(x: centerX, y: centerY), radius: 40, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: false)
        shapeLayer.path = path.cgPath
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        shapeLayer.autoreverses = true
        animation.duration = 3.0
        
        //设置动画
        animation.delegate = self
        shapeLayer.add(animation, forKey: nil)
        
        let count = 16
        for i in 0..<16 {
            
            let line = CAShapeLayer()
            line.fillColor = UIColor.clear.cgColor
            line.strokeColor = UIColor.yellow.cgColor
            line.lineWidth = 15.0
            line.lineCap = "round"
            line.lineJoin = "round"
            view.layer.addSublayer(line)
            
            let path2 = UIBezierPath()
            let x = centerX + 100 * cos(2.0*Double(i)*M_PI/Double(count))
            let y = centerY - 100 * sin(2.0*Double(i)*M_PI/Double(count))
            let len = 20
            path2.move(to: CGPoint.init(x: x, y: y))
            path2.addLine(to: CGPoint(x: x+Double(len)*cos(2*M_PI/Double(count)*Double(i)), y: y-Double(len)*sin(2*M_PI/Double(count)*Double(i))))
            line.path = path2.cgPath
            //line.add(animation, forKey: nil)
            
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //结束后设置整个填充为红色
        //shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        //shapeLayer.backgroundColor = UIColor.clear.cgColor
    }

}















