//
//  ViewController_Class.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

/*
 使用类的好处
    继承获得一个类的属性到其他类
 
    类型转换使用户能够在运行时检查类的类型
 
    初始化器需要处理释放内存资源
 
    引用计数允许类实例有一个以上的参考
 
 类和结构的共同特征
    属性被定义为存储值
 
    下标被定义为提供访问值
 
    方法被初始化来改善功能
 
    初始状态是由初始化函数定义
 
    功能被扩大，超出默认值
 
    确认协议功能标准
 */

class Student{
    var studentName: String = ""
    var mark: Int = 0
    //属性观察者
    var mark2: Int = 0 {
        willSet(newValue) {
            print(newValue)
        }
        didSet {
            if mark2 > oldValue {
                print("mark2 \(mark2) oldValue \(oldValue)")
            }
        }
    }
    //计算属性
    var total: Int {
        
        get {
            return mark + mark2
        }
        set {
            mark = newValue/2
            mark2 = newValue/2
        }
    }
    
    
}

class ViewController_Class: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let stu = Student.init()
        stu.mark = 10
        stu.mark2 = 30
        print(stu.total)
        
        //值类型嵌套引用类型的赋值
        var outer = Outer()
        var outer2 = outer
        outer2.value = 43
        outer.value = 43
        outer.inner.value = 43
        
        print("outer2.value = \(outer2.value), outer.value = \(outer.value) outer2.inner.value = \(outer2.inner.value) outer.inner.value = \(outer.inner.value)")
        
    }
}

class Innser {
    var value = 42
}

struct Outer {
    var value = 42
    var inner = Innser()
}
