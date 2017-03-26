//
//  WaveViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class WaveViewController: UIViewController {

    let waveView = WaveView(frame: CGRect.init(x: 0.0, y: 200, width: kScreenWidth, height: 31))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView.waveSpeed = 10
        waveView.angularSpeed = 1.5
        view.addSubview(waveView)
        waveView.startWave()
        
        //画三角函数
        let path = CGMutablePath()
        let layerr = CAShapeLayer()
        path.move(to: CGPoint.init(x: 0, y: 300))
        for i in stride(from: 0, to: kScreenWidth, by: 1) {
            print( "\(sin(CGFloat(i)))" )
            let arg = i/kScreenWidth * (2*CGFloat.pi)
            let y = 300+(sin(arg) * 100)
            path.addLine(to: CGPoint.init(x: i, y: y))
        }
        path.addLine(to: CGPoint.init(x: kScreenWidth, y: 300))
        path.addLine(to: CGPoint.init(x: kScreenWidth, y: 301))
        path.addLine(to: CGPoint.init(x: 0, y: 301))
        path.addLine(to: CGPoint.init(x: 0, y: 300))
        path.closeSubpath()
        layerr.path = path
        layerr.strokeColor = UIColor.black.cgColor
        layerr.fillColor = UIColor.black.cgColor
        view.layer.addSublayer(layerr)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if waveView.isWaveing {
            waveView.stopWave()
        }else{
            waveView.startWave()
        }
    }
}

class WaveView: UIView {
    
    var waveSpeed: CGFloat = 4.8
    var angularSpeed: CGFloat = 2.0
    var waveColor: UIColor = .blue
    var isWaveing:Bool = false
    
    private var waveDisplayLink: CADisplayLink?
    private var offsetX: CGFloat = 0.0
    
    private var waveShapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopWave() {
        UIView.animate(withDuration: 1, animations: { 
            self.alpha = 0
            }) { (finished) in
                self.waveDisplayLink?.invalidate()
                
                self.waveDisplayLink = nil
                self.waveShapeLayer?.removeFromSuperlayer()
                self.waveShapeLayer = nil
                self.isWaveing = false
                self.alpha = 1
        }
    }
    
    func startWave() {
        if waveShapeLayer != nil {
            return
        }
        
        waveShapeLayer = CAShapeLayer()
        waveShapeLayer?.fillColor = waveColor.cgColor
        layer.addSublayer(waveShapeLayer!)
        /*CADisplayLink:一个和屏幕刷新率相同的定时器，需要以特定的模式注册到runloop中，每次屏幕刷新时，会调用绑定的target上的selector这个方法。
         duration:每帧之间的时间
         pause:暂停，设置true为暂停，false为继续
         结束时，需要调用invalidate方法，并且从runloop中删除之前绑定的target跟selector。
         不能被继承
         */
        waveDisplayLink = CADisplayLink(target: self, selector: #selector(keyFrameWave))
        waveDisplayLink?.add(to: .main, forMode: .commonModes)
        self.isWaveing = true
    }
    
    func keyFrameWave() {
        
        offsetX -= waveSpeed
        let width = frame.size.width
        let height = frame.size.height
        
        //创建path
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: 0, y: height/2))
        
        
        var y: CGFloat = 0.0
        for x in stride(from: 0, to: width, by: 1) {
            y = height * sin(0.01*(angularSpeed * x + offsetX))
            path.addLine(to: CGPoint.init(x: x, y: y))
        }
        path.addLine(to: CGPoint.init(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        waveShapeLayer?.path = path
        
    }
    
    
    
}
