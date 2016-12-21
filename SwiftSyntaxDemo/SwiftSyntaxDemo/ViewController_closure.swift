//
//  ViewController_closure.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/19.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

class ViewController_closure: UIViewController {

    var someproperty = "hello"
    let ca = ClassA()
    
    //闭包别名
    typealias closure1 = (Int,Int) -> Int
    
    
    //
    let closureEscape :(String) -> Void = {
        (str :String) in {
            print(str)
        }()
    }
    
    // 定义 一般形式闭包
    let normalClosure :(Int,Int) -> Int = {
        (a:Int,b:Int) -> Int in {
            return a + b
        }()
    }
    
    // 根据闭包推断简化闭包
    let simpaClousure :(Int,Int) -> Int = {
        a,b in {
            return a+b
        }()
    }
    
    //再简化
    let simpa2Closure :closure1 = {
        a,b in a+b
    }
    
    //如果闭包没有参数,直接省略in
    let closure2 :() -> Double = {
        return 3.14
    }
    
    //简化  其实是定义了 一个无参，返回一个3.14 的闭包
    let closure2simple  = {
        3.14
    }
    
    //尾随闭包  概念:在使用时当函数的最后一个参数是闭包时，可以省略参数标签，将闭包表达式写在调用括号后面
    //origin
    func funcType2(property :Int,closure :(Int,Int)->Int) {
       print(closure(property,property))
    }
    //origin2
    func funcType2_2(clo :closure1){
        print(clo(3,4))
    }
    
    //值捕获 函数的方式
    func funcType3(sums :Int) -> ()->Int {
        var total = 0
        func innerFunction() -> Int {
            print("total \(total)  sums \(sums)")
            total = total + sums
            return total
        }
        return innerFunction
    }
    
    //值捕获 闭包方式
    func funcType3_2(sums :Int) -> ()->Int {
        var total = 0
        let block = { () -> Int in 
            print("total \(total)  sums \(sums)")
            total += sums
            return total
        }
        return block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ca.someMethod { 
            self.someproperty = "world"
        }
        print(someproperty)
        
        //闭包作为一个参数
        funcType1(normalClosure)
        funcType1(simpaClousure)
        funcType1(simpa2Closure)
        
        print(closure2())
        print(closure2simple())
        
        //尾随闭包
        funcType2(property: 5) { (a, b) -> Int in
            return a * b
        }
        
        funcType2_2 { (a, b) -> Int in
            return a * b
        }
        
        
        //值捕获
        let fun = funcType3(sums: 100)
        print("值捕获\(fun())")
        print("值捕获\(fun())")
        print("值捕获\(fun())")
        
        let fun2 = funcType3_2(sums: 100)
        print("值捕获\(fun2())")
        print("值捕获\(fun2())")
        print("值捕获\(fun2())")
        
        funcType4 { (abc) in
            print(abc)
        }
        print("functype 4 end ")
        
    }
    
    //func funcType1(_ addMethod: closure1) {  别名 == 下面那句效果
    func funcType1(_ addMethod: (Int,Int)->Int) {
        print(addMethod(5,5))//使用闭包参数
    }
    
    func funcType4(closure :@escaping (String)->Void) {
        
        let name = "name"
        //逃逸闭包  一般闭包做为函数参数都是非逃逸闭包，逃逸闭包需加入关键字@escaping
        //里面参数需要显示调用self
        DispatchQueue.global().async {
             closure(name)
         }
        
        //非逃逸闭包
        //closure("哈哈哈")
    }
    
    
    
}


class ClassA {
    
    func someMethod(Clousre : @escaping ()-> Void) {
        print("someMethod")
        Clousre()
    }
    
}
