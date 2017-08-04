//
//  ViewController_attributeString.swift
//  SwiftDemoKit
//
//  Created by runo on 17/8/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit



class ViewController_attributeString: UIViewController {

    
    let label = UILabel.init(frame: CGRect.zero)
    let tableView = UITableView.init(frame: kScreenBounds, style: .plain)
    let dataSource = [1,2,3,4,5,6,7,8]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame : CGRect = label.frame
        frame.size.height = 30
        frame.origin.y = 100
        label.frame = frame
        label.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin]
        //self.view.addSubview(label)
        
        //let string = "Testing Attribute String"
        
        
        
        //tableView 编辑模式下不缩进
        tableView.delegate = self
        tableView.dataSource = self
        //self.view .addSubview(tableView)
        self.tableView.setEditing(true, animated: true)
        
        
        
    }

}


extension ViewController_attributeString : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "index \(indexPath.row)"
        cell.editingAccessoryView = UIView.init()
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
