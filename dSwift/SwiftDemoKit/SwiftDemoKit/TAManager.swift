//
//  TAManager.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

enum TransitionType {
    case Pop
    case Push
}

class TAManager: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate{

    var type: TransitionType
    var transitionContext: UIViewControllerContextTransitioning? = nil
    
    init(Type type:TransitionType ) {
        self.type = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.type == .Pop {
            self.pushAnimateTransition(using: transitionContext)
        }else{
            self.popAnimateTransition(using: transitionContext)
        }
    }
    
    func pushAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //print(" push ")
        //该参数包含了控制转场动画必要的信息
        self.transitionContext = transitionContext
        //目标VC
        let toVC = transitionContext.viewController(forKey: .to)
        //当前VC
        let fromVC = transitionContext.viewController(forKey: .from)
        //容器View，转场动画都是在该容器中进行的，导航控制的wrapper view就是改容器
        let containerView = transitionContext.containerView
        containerView.addSubview((fromVC?.view)!)
        containerView.addSubview((toVC?.view)!)
        
        let starPath = UIBezierPath(rect: CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight))
        let finalPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalPath.cgPath
        toVC?.view.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = starPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.duration = transitionDuration(using: transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self
        maskLayer.add(animation, forKey: "path")
    }
    
    func popAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //print(" pop ")
        //该参数包含了控制转场动画必要的信息
        self.transitionContext = transitionContext
        //目标VC
        let toVC = transitionContext.viewController(forKey: .to)
        //当前VC
        let fromVC = transitionContext.viewController(forKey: .from)
        //容器View，转场动画都是在该容器中进行的，导航控制的wrapper view就是改容器
        let containerView = transitionContext.containerView
        containerView.addSubview((fromVC?.view)!)
        containerView.addSubview((toVC?.view)!)
        
        var starPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        var finalPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0, height: kScreenHeight))
        
        starPath = UIBezierPath(arcCenter: CGPoint.init(x: kScreenWidth/2, y: kScreenHeight/2), radius: 100, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        finalPath = UIBezierPath(arcCenter: CGPoint.init(x: kScreenWidth/2, y: kScreenHeight/2), radius: kScreenHeight/2, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalPath.cgPath
        toVC?.view.layer.mask = maskLayer
        maskLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //let animation = CABasicAnimation(keyPath: "strokeEnd")
        //transform.scale
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = starPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.duration = transitionDuration(using: transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self
        maskLayer.add(animation, forKey: "path")
    }
    
    //动画结束
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //通知transition完成,该方法一定要调用
        self.transitionContext?.completeTransition(!(self.transitionContext?.transitionWasCancelled)!)
        //清除fromVC的mask
        self.transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
        self.transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
    }
}
