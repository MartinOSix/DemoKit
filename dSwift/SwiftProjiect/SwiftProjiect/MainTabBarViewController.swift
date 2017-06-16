//
//  MainTabBarViewController.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/12.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor(red: 245 / 255.0, green: 90 / 255.0, blue: 93 / 255.0, alpha: 1)
        
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = UIColor(red: 245 / 255.0, green: 90 / 255.0, blue: 93 / 255.0, alpha: 1)
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 20)]
        //YMColor(r: 245, g: 90, b: 93, a: 1/0)
        self.addChildViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController?.childViewControllers.count == 1 {
            self.navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    func addChildViewControllers() {
        
        addChildViewController(DanTangViewController(), Title: "home", normalImage: #imageLiteral(resourceName: "TabBar_home_23x23_"), selectImage: #imageLiteral(resourceName: "TabBar_home_selected_23x23_"))
        addChildViewController(DanPinViewController(), Title: "gift", normalImage: #imageLiteral(resourceName: "TabBar_gift_23x23_"), selectImage: #imageLiteral(resourceName: "TabBar_gift_selected_23x23_"))
        addChildViewController(FenLeiViewController(), Title: "category", normalImage: #imageLiteral(resourceName: "TabBar_category_23x23_"), selectImage: #imageLiteral(resourceName: "TabBar_category_Selected_23x23_"))
        addChildViewController(WodeViewController(), Title: "me", normalImage: #imageLiteral(resourceName: "TabBar_me_boy_23x23_"), selectImage: #imageLiteral(resourceName: "TabBar_me_boy_selected_23x23_"))
    }
    
    func addChildViewController(_ childController: UIViewController, Title: String, normalImage: UIImage, selectImage: UIImage) {
        
        childController.tabBarItem.image = normalImage.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = selectImage.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.title = Title
        childController.navigationItem.title = Title

        let nav = UINavigationController.init(rootViewController: childController)
        addChildViewController(nav)
    }
    
    

}
