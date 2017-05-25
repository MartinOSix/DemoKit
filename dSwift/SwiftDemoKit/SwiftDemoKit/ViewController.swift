//
//  ViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    let dataSource = [("Collection创建使用","CollectionDemoViewController"),
                      ("定位框架只定位","LocationViewController"),
                      ("系统的下拉刷新控件","SystemDownUpPullRefreshViewController"),
                      ("线性颜色变换","GradientColorViewController"),
                      ("Scrollview查看Image","ImageScaleViewController"),
                      ("以视频为背景的view","VideoBackgroundController"),
                      ("颜色变换进度条","ColorProgressViewController"),
                      ("可以拉伸的tableviewHead","TableHeadViewController"),
                      ("tableViewCell刷新动画","AnimateTableViewController"),
                      ("shaplayer刷新动画","WaveViewController"),
                      ("画基本图型","DrawPaintViewController"),
                      ("基本动画,转圈","ShapeLayerAnimationViewController"),
                      ("转场动画","TransitionViewController"),
                      ("collectionviewcell点击动画","CollectionViewAnimationController"),
                      ("3dtouch","ThreeTouchViewController"),
                      ("session下载","URLImageViewController"),
                      ("cell左滑菜单，编辑状态","CellMenuViewController"),
                      ("colletion改变位置","CollectionChangePositionViewController"),
                      ("自定义collectionView布局","CustomeCollectionViewController"),
                      ("扫描和长按识别二维码","QRCodeViewController")
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

