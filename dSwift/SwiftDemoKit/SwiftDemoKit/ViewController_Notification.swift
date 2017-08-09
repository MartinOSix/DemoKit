//
//  ViewController_Notification.swift
//  SwiftDemoKit
//
//  Created by runo on 17/8/7.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ViewController_Notification: UIViewController {

    
    let input = UITextField.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 30)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        self.view.addSubview(btn)
        
        input.frame = CGRect.init(x: 100, y: 150, width: 100, height: 30)
        self.view.addSubview(input)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name("aaa"), object: nil, queue: nil) { (not) in
            
            guard let userinfo = not.userInfo,
                let message = userinfo["message"] as? String,
                let date = userinfo["date"] as? Date else{
            
                    print("get notification")
                    return
                }
            print("userinfo message:\(message)  date:\(date)")
        }
    }
    
    func btnclick() {
        print("btnclick")
        let inputText = input.text!
        let mailPattern = "\\w+@\\w+\\.[a-z]+(\\.[a-z]+)?"
        //"\\w+@\\w+\\.[a-z]+(\\.[a-z]+)?"
        //"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$"
        
        do{
            
            let matcher = try NSRegularExpression.init(pattern: mailPattern, options: .caseInsensitive)
            
            let result = matcher.matches(in: inputText, options: [], range: NSRange.init(location: 0, length: inputText.characters.count)).first
            if let length = result {
                if length.range.length > 0{
                NotificationCenter.default.post(name: Notification.Name("aaa"), object: nil, userInfo: ["message":"Hello YES","date":Date()])
                }else{
                    NotificationCenter.default.post(name: Notification.Name("aaa"), object: nil, userInfo: ["message":"Hello NO","date":Date()])
                }
            }else{
                NotificationCenter.default.post(name: Notification.Name("aaa"), object: nil, userInfo: ["message":"Hello NO","date":Date()])
            }
            
        }catch{
            
        }
        
        
    }

}
