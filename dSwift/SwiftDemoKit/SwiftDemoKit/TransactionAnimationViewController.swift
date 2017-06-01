//
//  TransactionAnimationViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class TransactionAnimationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {

    
    
    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight/2), style: .plain)
    let dataSource = [("重置","reset"),("淡入淡出","fade"),("推挤","push"),("揭开","reveal"),("覆盖","moveIn"),("立方体","cube"),("吮吸","suckEffect"),("翻转","oglFlip"),("波纹","rippleEffect"),("反翻页","pageCurl"),("开镜头","cameraIrisHollowOpen"),("关镜头","cameraIrisHollowClose")]
    
    let showView = UIView.init(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "转场动画"
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.showView.frame = CGRect.init(x: 100, y: kScreenHeight/2+100, width: 50, height: 50)
        self.showView.backgroundColor = UIColor.red
        //self.view.addSubview(self.showView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataSource[indexPath.row].0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.showView.removeFromSuperview()
            return
        }
        animationType(type: self.dataSource[indexPath.row].1)
    }
    
    func animationType(type :String) {
        let transation = CATransition.init()
        transation.repeatCount = 1
        transation.type = type
        transation.subtype = kCATransitionFromLeft
        transation.duration = 1
        self.view.layer .add(transation, forKey: "\(type)")
        self.view.addSubview(self.showView)
    }
    
    
    
}
