//
//  CustomeCollectionViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class CustomeCollectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let tableView = UITableView(frame: kScreenBounds, style: .plain)
    let reuseIdentifer = String(describing: UITableViewCell.self)
    let datas = ["瀑布流","圆形","线性"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "选择布局"
        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = true
        tableView.separatorStyle = .none
        //tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: 5)
        cell.textLabel?.textColor = .orange
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = ShowCollectionViewController()
        show.title = datas[indexPath.row]
        switch datas[indexPath.row] {
        case "瀑布流":
            show.style = "waterfall"
        case "圆形":
            show.style = "circle"
            
//            if let settingurl = URL.init(string: UIApplicationOpenSettingsURLString) {
//                //UIApplication.shared.openURL(settingurl)
//                UIApplication.shared.open(<#T##url: URL##URL#>, options: <#T##[String : Any]#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
//            }else{
//                print("null url")
//            }
 
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
            return
        default:
            show.style = "line"
        }
        navigationController?.pushViewController(show, animated: true)
    }

    
}
