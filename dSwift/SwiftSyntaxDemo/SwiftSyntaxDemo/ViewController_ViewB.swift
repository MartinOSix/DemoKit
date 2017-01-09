//
//  ViewController_ViewB.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

/*
 open
 open 修饰的 class 在 Module 内部和外部都可以被访问和继承
 open 修饰的 func 在 Module 内部和外部都可以被访问和重载（override）
 Public
 public 修饰的 class 在 Module 内部可以访问和继承，在外部只能访问
 public 修饰的 func 在 Module 内部可以被访问和重载（override）,在外部只能访问
 Final
 final 修饰的 class 任何地方都不能不能被继承
 final 修饰的 func 任何地方都不能被 Override
 */


//代理反向传值
public protocol ViewController_ViewB_Delegate : NSObjectProtocol {
    func getInfo(info :UIColor) -> Void
}

class ViewController_ViewB: UIViewController {

    private let tf = UITextField()//私有成员变量
    
    weak open var delegate: ViewController_ViewB_Delegate?//定义代理对象
    
    var block : ((String)->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        tf.frame = CGRect.init(x: 0, y: 20, width: screenWidth, height: 30)
        tf.backgroundColor = UIColor.red
        self.view.addSubview(tf)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (self.block != nil && tf.text != nil) {
            //self.block!(tf.text!)
        }
        
        if (self.delegate != nil) {
            self.delegate?.getInfo(info: UIColor.blue)
        }
        
        _ = self.navigationController?.popViewController(animated: true)
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
