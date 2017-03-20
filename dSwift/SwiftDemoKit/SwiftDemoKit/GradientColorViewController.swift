//
//  GradientColorViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/17.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class GradientColorViewController: UIViewController {

    let gradientLayer = CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.frame = kScreenBounds
        let redColor = UIColor.red.cgColor
        let blueColor = UIColor.blue.cgColor
        let yellowColor = UIColor.yellow.cgColor
        
        gradientLayer.colors = [redColor,blueColor,yellowColor]
        gradientLayer.locations = [0.20,0.30,0.50]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        view.layer.addSublayer(gradientLayer)
    }


}
