//
//  ViewController_Function.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/5.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

class ViewController_Function: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.functionType1()
        self.functionType2(Height: 10)
        self.functionType3(Height: 10, Width: 20)
        print("返回值\(self.functionType4(Height: 10, Width: 20))")
        var sum = 10
        self.functionType5(Sum: &sum)
        print("sum=\(sum)")
        
        self.functionType6(1, 2)
        let value = self.functionType7()
        print("第一个返回值\(value.a)")
        print("第二个返回值\(value.b)")
        //采用下标的方式返回
        print("第一个返回值\(value.0)");
        print("第二个返回值\(value.1)");
        
        self.functionType8(fun: functionType4)
        print("\(self.functionType5(Height: 1, Width: 2, Length: 3))")
        
        print("函数嵌套\n\(functionType9())");
        
        
        print("不定参数函数\n\(functionType11(parameters: 1,23,4,10))");
        
    }
    
    func functionType1(){
        print("无参无返回值函数")
    }
    
    func functionType2(Height: Int){
        print("带一个Int参数无返回值的函数\(Height)")
    }
    
    func functionType3(Height: Int, Width: Int){
        print("带两个Int参数的函数\(Height)和\(Width)")
    }
    
    func functionType4(Height: Int, Width: Int) -> Int {
        print("带两个Int参数的函数\(Height)和\(Width)返回两个数之和")
        return Height + Width
    }
    
    func functionType5(Height: Int, Width: Int, Length: Int) -> Int {
        print("函数重载")
        return Height * Width * Length
    }
    
    func functionType5(Sum:inout Int) {
        print("不管传进来的数是多少都会把原来的数改成0")
        Sum = 0
    }
    
    //一般冒号前面是参数名，如果只有一个默认是外部参数名 “_”表示忽略名字 空格后面表示内部参数名
    func functionType6(_ a:Int, _ b:Int) {
        print("忽略外部参数名的函数\(a)和\(b)")
    }
    
    func functionType7() -> (a:Int,b:Int) {
        print("元祖的形式返回两个参数")
        return (1,2)
    }
    
    func functionType8(fun:(Int,Int)->Int) {
        print("函数作为参数的形式执行结果为\(fun(10,20))")
    }
    
    //函数嵌套
    func functionType9() -> Int {
        
        func functionType10(num :Int) -> Int{
            return num * num
        }
        
        return functionType10(num: 2)
    }
    
    //可变参数的函数
    func functionType11(parameters :Int...) -> Int {
        
        var sum = 0
        for number in parameters {
            sum = sum + number
        }
        return sum
    }
    
}
