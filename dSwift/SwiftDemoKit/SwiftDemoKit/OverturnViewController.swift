//
//  OverturnViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/7/7.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class OverTurnView: UIView {
    
    var turnImage : UIImage!
    var imageViewUP = UIImageView()
    var imageViewDown = UIImageView()
    var shadomLayer = CAGradientLayer.init()
    var shadomLayerDown = CAGradientLayer.init()
    
    init(frame: CGRect,Image image: UIImage) {
        
        super.init(frame: frame)
        self.turnImage = image
        self.imageViewUP.frame =  CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height/2)
        self.imageViewDown.frame = CGRect.init(x: 0, y: frame.size.height/2, width: frame.width, height: frame.height/2)
        
        //设置imageView的展示区域只有原来image的上半部分
        self.imageViewUP.image = image
        self.imageViewUP.layer.contentsRect = CGRect.init(x: 0, y: 0, width: 1, height: 0.5)
        self.imageViewUP.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.imageViewUP.layer.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height/2)
        
        //展示下半部分
        self.imageViewDown.image = image
        self.imageViewDown.layer.contentsRect = CGRect.init(x: 0, y: 0.5, width: 1, height: 0.5)
        
        self.addSubview(imageViewUP)
        self.addSubview(imageViewDown)
        
        //添加下滑手势
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(sender:)))
        self.addGestureRecognizer(panGesture)
        
        
        //设置渐变图层
        shadomLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        shadomLayer.frame = self.imageViewDown.bounds
        shadomLayer.opacity = 0
        self.imageViewUP.layer.addSublayer(shadomLayer)
        
        shadomLayerDown.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        shadomLayerDown.frame = self.imageViewDown.bounds
        shadomLayerDown.opacity = 0
        self.imageViewDown.layer.addSublayer(shadomLayerDown)
    }
    
    func handlePanGesture(sender :UIPanGestureRecognizer) {
        
        let tranPoi = sender.translation(in: self)
        print(tranPoi.y)
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / 500.0
        let angle = -tranPoi.y / CGFloat(100.0*M_PI)
        self.imageViewUP.layer.transform = CATransform3DRotate(transform3D, angle, 1, 0, 0)
        self.shadomLayer.opacity = Float(tranPoi.y) / Float(1000.0)
        self.shadomLayerDown.opacity = Float(tranPoi.y) / Float(1000.0)
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.5, animations: { 
                self.imageViewUP.layer.transform = CATransform3DIdentity
                self.shadomLayer.opacity = 0
                self.shadomLayerDown.opacity = 0
            });
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class OverturnViewController: UIViewController {

    let testView = OverTurnView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100), Image: #imageLiteral(resourceName: "imagem.png"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(testView);
        
        
    }
}
