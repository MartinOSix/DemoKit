//
//  ViewController.swift
//  swiftreflect
//
//  Created by runo on 17/3/14.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nud = UserDefaults.standard.object(forKey: "qiniu")
        
        if nud != nil {
           print("\(nud)")
        }
        
        let qiniu = QiniuHostInfo(name: "name1", accessKey: "acc1", secretKey: "sec1")
        let qiniudata = NSKeyedArchiver .archivedData(withRootObject: qiniu)
        UserDefaults.standard.set(qiniudata, forKey: "qiniu")
        
        
    }

}


