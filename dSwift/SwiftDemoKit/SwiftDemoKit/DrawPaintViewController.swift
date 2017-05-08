//
//  DrawPaintViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/21.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class DrawPaintViewController: UIViewController {

    let pathView = DrawPaintView.init(frame: kScreenBounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.view.addSubview(pathView)
    }

}


class DrawPaintView: UIView {
    
    override func draw(_ rect: CGRect) {
        //圆角矩形
        let roundPath = UIBezierPath(roundedRect: CGRect.init(x: 20, y: 20, width: 100, height: 100), cornerRadius: 20)
        roundPath.lineWidth = 5
        UIColor.green.set()
        roundPath.fill()
        UIColor.red.set()
        roundPath.stroke()
        
        //圆弧
        let arcPath = UIBezierPath()
        arcPath.move(to: CGPoint.init(x: 20, y: 150))
        arcPath.addLine(to: CGPoint.init(x: 120, y: 150))
        arcPath.addArc(withCenter: CGPoint.init(x: 20, y: 150), radius: 100, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        arcPath.close()
        arcPath.lineCapStyle = .square
        arcPath.lineJoinStyle = .bevel//miter bevel
        arcPath.lineWidth = 5
        UIColor.red.set()
        arcPath.stroke()
        
        //三角形
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: 20, y: 300))
        triangle.addLine(to: CGPoint.init(x: 150, y: 400))
        triangle.addLine(to: CGPoint.init(x: 20, y: 400))
        triangle.close()
        triangle.lineWidth = 5
        UIColor.green.set()
        triangle.fill()
        UIColor.red.set()
        triangle.stroke()
        
        //贝塞尔曲线
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.init(x: 170, y: 50))
        bezierPath.addQuadCurve(to: CGPoint.init(x: 170, y: 400), controlPoint: CGPoint.init(x: kScreenWidth-20, y: 200))
        bezierPath.lineWidth = 5
        UIColor.red.set()
        bezierPath.stroke()
        
        
    }
    
}










