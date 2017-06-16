//
//  TopicViewController.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import MJRefresh

class TopicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var currentChannel: HomeItemModel? = nil
    var tableView: UITableView? = nil
    var dataSource = [TopicItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self.currentChannel?.name) viewDidLoad \(self.view.frame.size)")
        self.view.backgroundColor = UIColor.arcColor()
        
        setupTableView()
    }
    
    func setupTableView() {
        
        self.tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        weak var WeakSelf = self
        self.tableView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            WeakSelf?.requestTopicData()
        })
        self.view.addSubview(self.tableView!)
        
        self.tableView?.separatorStyle = .none
        self.tableView?.register(UINib.init(nibName: "TopicTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.tableFooterView = UIView()
    }
    
    func requestTopicData() {
        
        NetworkUtil.sharUtil.loadTopicItem(id: (self.currentChannel?.id)!) { (items) in
            self.tableView?.mj_header.endRefreshing()
            self.dataSource = items
            self.tableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TopicTableViewCell
        cell.loadItemModel(model: self.dataSource[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:test life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        if self.dataSource.count == 0 {
            self.tableView?.mj_header.state = .refreshing
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(self.currentChannel?.name) viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("\(self.currentChannel?.name) viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("\(self.currentChannel?.name) viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        print("\(self.currentChannel?.name) viewDidLayoutSubviews \(self.view.frame.size)")
        self.tableView?.cq_size = self.view.frame.size
    }
    
}
