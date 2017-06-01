//
//  DeepProtocolViewController.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 17/5/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

//使用协议增加属性
protocol DeepProtocol {
    var name: String {get set}
    var birthPlace: String { get }
    static var qualification: String {get}
}

class StuClass: DeepProtocol {
    
    var name: String = ""
    var birthPlace: String = ""
    
    static var qualification: String {
        return "high"
    }
    
}

class DeepProtocolViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let stu = StuClass()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
