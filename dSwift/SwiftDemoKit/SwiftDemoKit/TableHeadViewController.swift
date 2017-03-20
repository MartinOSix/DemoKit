//
//  TableHeadViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit


class TableHeadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let datas = ["下拉"]
    let tableView = UITableView.init(frame: kScreenBounds, style: .plain)
    let headView = UIImageView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kScreenWidth, height: kScreenHeight/3.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        headView.backgroundColor = .white
        headView.contentMode = .scaleAspectFill
        headView.clipsToBounds = true
        view.addSubview(headView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = kScreenHeight/3.0
        view.sendSubview(toBack: tableView)
        //加载图片
        let url = URL.init(string: "http://c.hiphotos.baidu.com/zhidao/pic/item/5ab5c9ea15ce36d3c704f35538f33a87e950b156.jpg")

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let _ = data,error == nil else { return }
            //回到主线程
            DispatchQueue.main.sync {
                self.headView.image = UIImage.init(data: data!)
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = datas[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.headView.frame.size.height = scrollView.contentOffset.y * -1
    }
    

}
