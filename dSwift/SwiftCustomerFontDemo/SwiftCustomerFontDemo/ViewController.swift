//
//  ViewController.swift
//  SwiftCustomerFontDemo
//
//  Created by runo on 17/3/15.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

let kscreenWidht = UIScreen.main.bounds.size.width
let kscreenHeight = UIScreen.main.bounds.size.height


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView: UITableView?
    var fontBtn: UIButton?
    let titleArr = ["哈哈哈","abc123","呵呵呵呵","拉开家分店","阿里所肩负的"]
    let fontArr = ["MFJinHei_Noncommercial-Regular",
                   "MFTongXin_Noncommercial-Regular",
                   "MFZhiHei_Noncommercial-Regular"]
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: kscreenWidht, height: kscreenHeight*0.8), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView!)
        
        fontBtn = UIButton(type: .custom)
        fontBtn?.frame = CGRect(x: 0, y: kscreenHeight*0.8, width: kscreenWidht, height: kscreenHeight*0.2)
        fontBtn?.backgroundColor = UIColor.lightGray
        fontBtn?.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        view.addSubview(fontBtn!)
        
    }

    func btnclick() {
        currentIndex = Int(arc4random_uniform(UInt32(fontArr.count)))
        print("currentIndex \(currentIndex)")
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = titleArr[indexPath.row]
        cell?.textLabel?.font = UIFont.init(name: fontArr[currentIndex], size: 17)
        return cell!
    }
    
}

