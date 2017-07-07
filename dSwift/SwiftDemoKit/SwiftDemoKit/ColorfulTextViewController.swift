//
//  ColorfulTextViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/7/7.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ColorfulTextViewController: UIViewController {

    
    var displayLink : CADisplayLink!
    var gradientLayer : CAGradientLayer!
    var colors : [CGColor]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel.init()
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        label.text = "只是一段测试文字"
        label.font = UIFont.systemFont(ofSize: 25)
        label.sizeToFit()
        label.center = CGPoint(x: 200, y: 200)
        self.view.addSubview(label)
        
        gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = label.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.colors = [UIColor.randomColor().cgColor,UIColor.randomColor().cgColor,UIColor.randomColor().cgColor]
        gradientLayer.colors = self.colors
        self.view.layer.addSublayer(gradientLayer)
        gradientLayer.mask = label.layer
        label.frame = gradientLayer.bounds
        
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(handleDisplayLink))
        self.displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        self.displayLink.preferredFramesPerSecond = 60
    }
    
    
    func handleDisplayLink() {
        
        self.colors .removeLast()
        self.colors.insert(UIColor.randomColor().cgColor, at: 0)
        self.gradientLayer.colors = self.colors
    }
}



















