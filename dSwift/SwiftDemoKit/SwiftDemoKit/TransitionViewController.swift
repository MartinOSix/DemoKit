//
//  TransitionViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: CGFloat(arc4random()%255)/255, green: CGFloat(arc4random()%255)/255, blue: CGFloat(arc4random()%255)/255, alpha: 1)
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TAManager.init(Type: .Push)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TAManager.init(Type: .Pop)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.navigationController?.pushViewController(TransitionViewController(), animated: true)
    }
}
