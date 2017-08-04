//
//  ViewController_controlFlow.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/26.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

class ViewController_controlFlow: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.funType_For()
        self.funcType_While()
        self.funcType_if()
        self.funcType_Switch()
        // Do any additional setup after loading the view.
        
        var name : String? = nil;
        name = "name"
        guard name != nil else {
            print("name is nil")
            return;
        }
        print("\(name) is not nil")
        
        if let name1 = name{
            print("\(name1) is not nil")
        }
        
    }
    
    func funType_For() {
        
        for index in 1...5 {
            print("index = \(index)")
        }
        
        for _ in 1...5 {
            print("lalal ")
        }
        
        let names = ["alex","alen","haha"]
        
        for name in names {
            print(name)
        }
        
        let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
        for (animalName, legCount) in numberOfLegs {
            print("\(animalName)s have \(legCount) legs")
        }
        
        //直接遍历字符串
        for character in "Hello".characters {
            print(character)
        }
        let charArr = Array("Hello".characters)
        print(charArr)
//      swift 3 完全移除了这种语法
//        for var indexx = 0; indexx < 5; indexx++ {
//            print(indexx)
//        }
        
    }
    
    func funcType_While() {
        var condition = 10
        while condition > 0 {
            print(condition)
            condition -= 1
        }
        
        
        repeat{
            print(condition)
            condition += 1
        } while condition < 10
        
    }
    
    func funcType_if() {
        var temperature = 30
        if temperature > 32 {
            print("temperature High")
        }else{
            print("temperature low")
        }
        
        temperature += 20
        
        if temperature > 30 {
            print("Hight")
        }else if temperature > 20{
            print("Middle")
        }else{
            print("Low")
        }
    }
    
    
    func funcType_Switch() {
        
        //匹配字符
        let char = "e"
        switch char {
        case "a","b","c","d","e" :
            print("5")
        default:
            print("NO")
        }
        
        //匹配范围
        let i = 5
        switch 1 {
        case 1...5:
            print("1...5")
        default:
            print("other")
        }
        
        //元祖匹配
        let tup = (1,1)
        switch tup {
        case (0,0):
            print("nothing")
        case (1,_):
            print("1,x")
            fallthrough
        case (_,1):
            print("x,1")
        default:
            print("hhhh")
        }
        
        //值绑定
        let anotherPoint = (2, 0)
        switch anotherPoint {
        case (let x, 0):
            print("on the x-axis with an x value of \(x)")
            
        case (0, let y):
            print("on the y-axis with a y value of \(y)")
            
        case let (x, y):
            print("somewhere else at (\(x), \(y))")
        }
        
        //进一步判断
        let point = (1,4)
        
        switch point {
        case (1,let y) where y > 5:
            print("x = 1 , y > 5")
        case (1, let y) where y < 5:
            print("x = 1 , y < 5")
        default:
            print("other")
        }
        
        //continue 终止当次循环
        //break 跳出当前循环
        //return 跳出方法
        
    }
    
    
    
    
    
    
    
    
    
    
    
    

}
