//
//  ViewController.swift
//  SwiftProjiect
//
//  Created by runo on 17/5/26.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import FDFullscreenPopGesture


class ViewController: UITableViewController {

    
    let dataSource = [("SVProgressHUD创建使用","SVProgressHudDemoTableViewController"),
                      ("队列下载","DownloadQueueViewController")
                      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.dataSource[indexPath.row].0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return
        }
        
        let classString = dataSource[indexPath.row].1
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + classString)
        
        if classString.compare("DownloadQueueViewController") == .orderedSame {
            
            let vc = DownloadQueueViewController(nibName: "Empty", bundle: nil)
            vc.view.backgroundColor = UIColor.white
            vc.title = dataSource[indexPath.row].0
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return
        }
        let vc = clsType.init()
        vc.view.backgroundColor = UIColor.white
        vc.title = dataSource[indexPath.row].0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

