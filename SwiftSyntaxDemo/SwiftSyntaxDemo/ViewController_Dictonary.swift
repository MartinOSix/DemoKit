//
//  ViewController_Dictonary.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/26.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

class ViewController_Dictonary: UIViewController {

    /*
        swift 字典的键是必须可哈希的
        基础类型 String Int Double Bool 是可哈希的
        枚举成员中没有绑定值的值默认也是可哈希的
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var namesOfIntegers = Dictionary<Int,String>()
        print(namesOfIntegers)
        namesOfIntegers[15] = "fifteen"
        print(namesOfIntegers)
        namesOfIntegers = [:] //又变成了空字典
        
        
        var airports : Dictionary<String,String> = ["TYO":"Tokyo","DUB":"Dublin"]
        
        //字典键值对数量
        print("ariports count = \(airports.count)")
       
        //添加 修改
        airports["LHR"] = "London"//没有则添加
        print(airports)
        airports["LHR"] = "NewYork"//有则是修改
        print(airports)
        
        if let val = airports["HAHA"]{
            print(val)
        }else{
            print("the airports not contain HAHA")
        }
        //使用updateValue（forKey）替代下标
        //不存在添加， 存在就更新
        
        if let oldvalue = airports.updateValue("Dublin International", forKey: "HUD") {
            print("the old value for DUB was \(oldvalue)")
        }else{
            print("is new Value")
        }
        print(airports)
        airports["HUD"] = nil //赋值nil来删除
        print(airports)
        
        //字典中删除键值对也可以使用removeValueForKey函数。如果该键值对存在，该函数就返回本删掉的值，如果不存在，就返回nil
        
        //遍历
        for (key,value) in airports {
            print("\(key)  \(value)")
        }
        
        for key in airports.keys {
            print("key = \(key)")
        }
        
        for value in airports.values {
            print("value = \(value)")
        }
        
        let keysArr = Array(airports.keys)
        let valuearr = Array(airports.values)
        
        print("keysArr \(keysArr) \n valuesArr \(valuearr)")
     
        //字典的拷贝行为
        var ages = ["peter":23,"wei":35,"anni":64]
        var copyAge = ages
        print("ages \(ages)  copy \(copyAge)")
        
        ages["peter"] = 24
        print("ages \(ages)  copy \(copyAge)")
        self.changeAge(dic: &copyAge)
        print("ages \(ages)  copy \(copyAge)")
    }
    
    func changeAge( dic :inout Dictionary<String,Int>) {
        
        dic["peter"] = 99
        
    }
    
    
}
