//
//  SearchResultViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

enum StudentType {
    case pupil(String)
    case middleStudent(String)
    case collegeStudent(String)
}


class SearchResultViewController: UITableViewController {

    
    var datasource :[String]? = [String]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pupilStu = StudentType.pupil("小学生")
        switch pupilStu {
        case .pupil(let name):
            print(name)
        default: break
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.datasource?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = datasource?[indexPath.row]
        return cell
    }
    

}
