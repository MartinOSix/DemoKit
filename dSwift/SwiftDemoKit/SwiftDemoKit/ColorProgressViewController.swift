//
//  ColorProgressViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ColorProgressViewController: UIViewController {

    
    var progressView: ColorProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var progre: CGFloat = 0.0
        progressView = ColorProgress.init(frame: CGRect.init(x: 20, y: 100, width: kScreenWidth-40, height: 20))
        progressView?.progress = progre
        view.addSubview(progressView!)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (time) in
            progre = progre+0.1<=1 ? progre+0.1 : 0
            self.progressView?.progress = progre
        }
        
    }

}


class ColorProgress: UIView, CAAnimationDelegate {
    
    let gradientLayer = CAGradientLayer()
    let maskLayer = CALayer()
    var progress: CGFloat = 0.0 {
        didSet {
            changeMaskFrame()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let whiterBG = CALayer()
        whiterBG.frame = bounds
        whiterBG.cornerRadius = bounds.size.height/2.0
        whiterBG.borderColor = UIColor.white.cgColor
        whiterBG.borderWidth = 1.0
        layer.addSublayer(whiterBG)
        
        gradientLayer.frame = bounds
        gradientLayer.borderColor = UIColor.white.cgColor
        gradientLayer.cornerRadius = bounds.size.height/2.0
        gradientLayer.borderWidth = 1.0
        var colors = [CGColor]()
        for hue in stride(from: 0, to: 360, by: 5) {
            let color = UIColor(hue: CGFloat(hue)/360.0, saturation: 1.0, brightness: 1.0, alpha: 1).cgColor
            colors.append(color)
        }
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
        //添加显示区域
        changeMaskFrame()
        maskLayer.cornerRadius = bounds.size.height/2.0
        maskLayer.backgroundColor = UIColor.white.cgColor
        gradientLayer.mask = maskLayer
        
        performAnimation()
    }
    
    func changeMaskFrame() {
        maskLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: progress*bounds.size.width, height: bounds.size.height)
    }
    
    func performAnimation() {
        var colors = gradientLayer.colors
        let color = colors?.popLast() as! CGColor
        colors?.insert(color, at: 0)
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = colors
        animation.duration = 0.08
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        gradientLayer.add(animation, forKey: "gradient")
        gradientLayer.colors = colors
    }
    
    //动画停止后继续动画
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        performAnimation()
    }
    
}





















