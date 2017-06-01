//
//  SearchViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchResultsUpdating {

    
    let tableview = UITableView(frame: kScreenBounds, style: .plain)
    var searchVC:UISearchController? = nil
    var dataSource = [String]()
    let resultVC = SearchResultViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        for _ in 0...100 {
            
            dataSource.append("\(arc4random()%100*10)")
        }
        
        self.view.addSubview(tableview)
        self.searchVC = UISearchController(searchResultsController: resultVC)
        self.searchVC?.dimsBackgroundDuringPresentation = true//搜索时关闭当前控制器功能
        self.searchVC?.searchResultsUpdater = self//刷新代理
        self.definesPresentationContext = true
        self.tableview.tableHeaderView = self.searchVC?.searchBar
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchtxt = searchController.searchBar.text
        let filtered = self.dataSource.filter({ (ele) -> Bool in
            return ele.contains(searchtxt!)
        })
        resultVC.datasource = filtered
        resultVC.tableView.reloadData()
    }
    
    
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.dataSource[indexPath.row]
        return cell
    }
    
    
}

