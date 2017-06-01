//
//  TableViewController.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 17/5/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    let dataSource = [("定义方法","ViewController_Function"),
                      ("多线程","ViewController_MultThread"),
                      ("闭包","ViewController_closure"),
                      ("枚举，结构体，类，协议","ViewController_enum_Struct_class_protocol"),
                      ("任意类型","ViewController_AnyObject"),
                      ("类","ViewController_Class"),
                      ("数组","ViewController_Array"),
                      ("字典","ViewController_Dictonary"),
                      ("控制流","ViewController_controlFlow"),
                      ("深入理解协议","DeepProtocolViewController")
        ] as [(String,String)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = kScreenBounds
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = dataSource[indexPath.row].0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return
        }
        
        let classString = dataSource[indexPath.row].1
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + classString)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UITableViewController")
            return
        }
        
        let vc = clsType.init()
        vc.title = dataSource[indexPath.row].0
        vc.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
