//
//  SystemDownUpPullRefreshViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/17.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class SystemDownUpPullRefreshViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
    let refreshControl = UIRefreshControl()//只能下拉不能上拉
    var dataSourceArr = ["first"]
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableview.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-44)
        
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.tableFooterView = UIView.init()//这样不显示多余的view
        tableview.refreshControl = refreshControl
        refreshControl.backgroundColor = UIColor.cyan
        refreshControl.attributedTitle = NSAttributedString(string: "最后一次更新：\(NSDate())",attributes: [NSForegroundColorAttributeName: UIColor.black])//文字的颜色
        refreshControl.tintColor = UIColor.orange//菊花颜色
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        view.addSubview(tableview)
    }
    
    func refreshData() {
        
        
        DispatchQueue.global().async {
            sleep(3)
            print("refreshData")
            self.dataSourceArr.append("\(NSDate())")
            self.refreshControl.endRefreshing()
            self.tableview .reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataSourceArr[indexPath.row]
        return cell
    }

}
