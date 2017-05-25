//
//  ThreeTouchViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/8.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ThreeTouchViewController: UIViewController {

    let tabView = UITableView.init(frame: CGRect.init(x: 0, y: 164, width: kScreenWidth, height: kScreenHeight-164), style: .plain)
    /*
    lazy var previewActions: [UIPreviewActionItem] = {
        func previewActionForTitle(title: String, style: UIPreviewActionStyle = .default) -> UIPreviewAction {
            
            return UIPreviewAction.init(title: title, style: style, handler: { (act, vc) in
                print("\(vc)")
            })
            
        }
        
        let action1 = previewActionForTitle(title: "default Action")
        let action2 = previewActionForTitle(title: "destruction Action", style: .destructive)
        
        let subAction1 = previewActionForTitle(title: "sub action1")
        let subAction2 = previewActionForTitle(title: "sub action2")
        let groupedActions = UIPreviewActionGroup(title: "subactions", style: .default, actions: [subAction1,subAction2])
        return [action1,action2,groupedActions]
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let touc = touchView.init(frame: kScreenBounds)
        touc.frame.size.height = 164;
        self.view.addSubview(touc)
        
        self .registerForPreviewing(with: self, sourceView: touc)
        self.view.addSubview(tabView)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tabView.tableFooterView = UIView.init()
    }
}

extension ThreeTouchViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabView.dequeueReusableCell(withIdentifier: "cell")
        if indexPath.row%2 == 0 {
            cell?.backgroundColor = UIColor.lightGray
            cell?.textLabel?.text = "1111111111111111111111111"
        }else{
            cell?.backgroundColor = UIColor.gray
            cell?.textLabel?.text = "222222222222222222222222"
        }
        self .registerForPreviewing(with: self, sourceView: cell!)
        return cell!
    }
    
}

extension ThreeTouchViewController: UIViewControllerPreviewingDelegate{
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return ShapeLayerAnimationViewController()
    }
    
}

class touchView: UIView {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       let touch = touches.first!
        
        if self.traitCollection.forceTouchCapability == .available {
            print("--- 可用")
        }
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: touch.force/touch.maximumPossibleForce)
    }
    
}
