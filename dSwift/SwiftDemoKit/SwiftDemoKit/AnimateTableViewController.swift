//
//  AnimateTableViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class AnimateTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableData = ["Read 3 article on Medium", "Cleanup bedroom", "Go for a run", "Hit the gym", "Build another swift project", "Movement training", "Fix the layout problem of a client project", "Write the experience of #30daysSwift", "Inbox Zero", "Booking the ticket to Chengdu", "Test the Adobe Project Comet", "Hop on a call to mom", "Movement training", "Fix the layout problem of a client project", "Write the experience of #30daysSwift", "Inbox Zero", "Booking the ticket to Chengdu", "Test the Adobe Project Comet", "Hop on a call to mom"]
    let tableView = UITableView(frame: kScreenBounds, style: .plain)
    let reuseIdentifier = "CustomCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
    }
    
    func animateTable() {
        tableView.reloadData()
        //所有可见的cell
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        
        for (index,cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0,
                           delay: 0.05*Double(index),
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
                },
                           completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell?.backgroundColor = .orange
        return cell!
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateTable()
    }
    
}
