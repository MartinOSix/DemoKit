//
//  ViewController_ViewA.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height



class ViewController_ViewA: UIViewController,ViewController_ViewB_Delegate {
    
    
    
    let label = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        label.frame = CGRect.init(x: 0, y: 20, width: screenWidth, height: 30)
        self.view.addSubview(label)
        label.backgroundColor = UIColor.red
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0);

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let viewB = ViewController_ViewB()
        viewB.block = {
            (txt :String)->Void in {
                self.label.text = txt
            }()
        }
        viewB.delegate = self
        self.navigationController?.pushViewController(viewB, animated: true)
        
    }

    func getInfo(info: UIColor) {
        self.view.backgroundColor = info
    }
    
}
