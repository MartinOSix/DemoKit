//
//  CellMenuViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/12.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class CellMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var datas = [String]()
    let tableview = UITableView.init(frame: kScreenBounds, style: .plain)
    let reuseIdentifer = String(describing: UITableViewCell.self)
    var rightbtn:UIBarButtonItem?
    var tableviewEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableview)
        for index in 0...20 {
            datas.append("index \(index)")
        }
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        tableview.allowsMultipleSelection = true
        //编辑模式下是否可以选中
        //tableview.allowsSelectionDuringEditing = false;
        
        //编辑状态下多选
        tableview.allowsMultipleSelectionDuringEditing = true;
        tableview.allowsSelectionDuringEditing = true;
        
        
        self.rightbtn = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(rightbtnclick))
        self.navigationItem.rightBarButtonItem = self.rightbtn
        
    }
    
    func rightbtnclick() {
        
        self.tableview.setEditing(!self.tableviewEditing, animated: true)
        self.tableviewEditing = !self.tableviewEditing
        if self.tableviewEditing {
            self.rightbtn?.title = "取消"
        }else{
            self.rightbtn?.title = "编辑"
        }
 
        //tableview.deselectRow(at: IndexPath.init(row: 5, section: 0), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer)
        cell?.textLabel?.text = datas[indexPath.row]
        let bgview = UIView.init(frame: (cell?.bounds)!)
        bgview.backgroundColor = .green
        cell?.selectedBackgroundView = bgview
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction.init(style: .destructive
            , title: "删除") { (action, indexpatch) in
                self.datas.remove(at: indexpatch.row)
                self.tableview.deleteRows(at: [indexpatch], with: .middle)
                print("index \(indexPath.row) 删除")
        }
        let action2 = UITableViewRowAction.init(style: .default, title: "default") { (act, ind) in
            print("default click \(ind.row)")
        }
        let action3 = UITableViewRowAction.init(style: .normal, title: "normal") { (act, ind) in
            print("normal click \(ind.row)")
        }
        return [action1,action2,action3]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableview.indexPathsForVisibleRows)
    }

}
