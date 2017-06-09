//
//  UIDynamicMenuViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/6/2.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class UIDynamicMenuViewController: UIViewController {

    let tableView = UITableView.init(frame: kScreenBounds, style: .plain)
    let blueView = UIView.init(frame: CGRect.init(x: kScreenWidth/2, y: kScreenHeight/2, width: 50, height: 50))
    let dataSource = ["重力行为","甩行为","猛推一把","吸附行为"]
    let redView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
    var animator = UIDynamicAnimator.init()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.redView.backgroundColor = UIColor.red
        self.blueView.backgroundColor = UIColor.blue
        self.view.addSubview(redView)
        self.view.addSubview(blueView)
        
        animator = UIDynamicAnimator.init(referenceView: self.view)
    }
    
    
    func pushAnimation() {
        self.animator.removeAllBehaviors()
        
        //创建一个瞬时推力
        let pushBehavior = UIPushBehavior.init(items: [self.blueView], mode: .instantaneous)
        //是否激活，瞬时推力要激活
        pushBehavior.active = true
        //角度
        pushBehavior.angle = 0
        //力度
        pushBehavior.magnitude = 10
        self.animator.addBehavior(pushBehavior)
        
        //碰撞行为
        let collisionBehavior = UICollisionBehavior.init(items: [self.redView,self.blueView])
        //collisionBehavior.collisionMode = .items
        //与自己父view的边界碰撞
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(collisionBehavior)
    }
    
    func attachmentAnimation() {
        
        self.animator.removeAllBehaviors()
        let attachmentBehavior = UIAttachmentBehavior.init(item: self.redView, attachedTo: self.blueView)
        //振幅
        attachmentBehavior.damping = 0
        //频率
        attachmentBehavior.frequency = 10
        //距离
        attachmentBehavior.length = 50
        self.animator.addBehavior(attachmentBehavior)
        
    }
    
    func snapAnimation() {
        self.animator.removeAllBehaviors()
        let arcPoint_x = arc4random()%UInt32.init(kScreenWidth)
        let arcPoint_y = arc4random()%UInt32.init(kScreenHeight)
        
        let snapBehavior = UISnapBehavior.init(item: self.redView, snapTo: CGPoint.init(x: Int.init(arcPoint_x), y: Int.init(arcPoint_y)))
        print("x:\(arcPoint_x) y:\(arcPoint_y)")
        self.animator.addBehavior(snapBehavior)
        
        
        //碰撞行为
        let collisionBehavior = UICollisionBehavior.init(items: [self.redView,self.blueView])
        //与自己父view的边界碰撞
        //collisionBehavior.collisionMode = .items
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(collisionBehavior)
    }
    
    func grativeAnimation() {
        
        self.animator.removeAllBehaviors()
        
        let gravityBehavior = UIGravityBehavior.init(items: [self.redView])
        //方向
        gravityBehavior.gravityDirection = CGVector.init(dx: 0, dy: -1)
        //力度
        gravityBehavior.magnitude = 1
        self.animator.addBehavior(gravityBehavior)
        
        //碰撞行为
        let collisionBehavior = UICollisionBehavior.init(items: [self.redView,self.blueView])
        //与自己父view的边界碰撞
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(collisionBehavior)
        
    }
}

extension UIDynamicMenuViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            grativeAnimation()
        case 1:
            snapAnimation()
        case 2:
            pushAnimation()
        case 3:
            attachmentAnimation()
        default:
            break
        }
    }
}
