//
//  ViewController_shareFile.swift
//  SwiftDemoKit
//
//  Created by runo on 17/8/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController_shareFile: UIViewController {

    let playerVC = AVPlayerViewController.init()
    let tableview = UITableView.init(frame: kScreenBounds, style: .plain)
    var datasource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        self.view .addSubview(tableview)
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        print(filePath)
        guard FileManager.default.subpaths(atPath: filePath) != nil else {
            print("subfile is nil")
            return;
        }
        for subFile in FileManager.default.subpaths(atPath: filePath)! {
            self.datasource .append(subFile)
        }
        self.tableview .reloadData()
    }
    
}

extension ViewController_shareFile: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let filePath = self.datasource[indexPath.row]
        
        if filePath.hasSuffix("rmvb") || filePath.hasSuffix("mkv") {
            
            var fullPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            fullPath.append("/\(self.datasource[indexPath.row])")
            print("fullpath \(fullPath)")
            let activityItems = [fullPath];
            let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
         
            var filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            filePath.append("/\(self.datasource[indexPath.row])")
            
            print("delete file Path \(filePath)")
            self.datasource.remove(at: indexPath.row)
            
            do {
                try FileManager.default.removeItem(atPath: filePath)
            }catch{
                print(error)
            }
            self.tableview.deleteRows(at: [indexPath], with: .middle)
            
        }
    }
    
}
