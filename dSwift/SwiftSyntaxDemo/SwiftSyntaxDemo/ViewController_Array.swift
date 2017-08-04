//
//  ViewController_Array.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/23.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

class ViewController_Array: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.createArray()
        
        //self.anyArray()
        
        arrayMapFunction()
    }
    
    
    func arrayMapFunction() {
        
        let oldArr = (1...8)
        let newArr = oldArr.map { (a) -> Int in
            return a*a
        }
        print(newArr)
     
        let arr1 = [Optional("1234"),nil,Optional("hahha")]
        
        let arr1_n = arr1.map { (arg1) -> String in
            if let str = arg1 {
                return str
            }
            return ""
        }
        print(arr1_n)
        
        let arr1_n2 = arr1.filter { (arg1) -> Bool in
            if let str = arg1 {
                return true
            }
            return false
        }
        print(arr1_n2)
        
        //线程组
        let group = DispatchGroup.init();
        
        //异步任务一
        let workItem1 = DispatchWorkItem.init {
            
            print("thread 1 Start")
            for i in 1...10 {
                sleep(1)
                print("thread 1  -- \(i)");
            }
            print("thread 1 End")
        }
        
        //将异步任务添加到线程组中，并开始异步执行
        DispatchQueue.global().async(group: group, execute: workItem1);
    
        let workItem2 = DispatchWorkItem.init {
            
            print("thread 2 Start")
            for i in 1...5 {
                sleep(2)
                print("thread 2  -- \(i)");
            }
            print("thread 2 End")
        }
        DispatchQueue.global().async(group: group, execute: workItem2);
        
        let workItem3 = DispatchWorkItem.init {
            
            print("thread 3 Start")
            for i in 1...15 {
                sleep(1)
                print("thread 3  -- \(i)");
            }
            print("thread 3 End")
            
        }
        DispatchQueue.global().async(group: group, execute: workItem3);
        
        
        //线程组中所有线程执行完毕所走的通知
        group.notify(queue: DispatchQueue.main) { 
            
            print("所有线程执行完毕")
            
        }
        
        
    }
    
    
    

    func anyArray() {
        
        //
        let strArr : Dictionary<String , Int> = ["hehe":1,"haha":1,"a":3]
        
        for tmp in strArr.keys {
            if tmp == "haha" {
                print(strArr[tmp])
            }
        }
        print(strArr)
        
        let str = "abbcddeff"
        let arr = str.characters
        var marr = [(Character,Int)]()
        for char in arr {
            var hasAdd = true
            for (index,value) in marr.enumerated() {
                if value.0 == char {
                    marr[index] = (char,value.1 + 1)
                    hasAdd = false
                    break
                }
            }
            if hasAdd {
                marr.append((char,1))
            }
//            if marr.keys.contains(char) {
//                var i = marr[char]!
//                i += 1
//                marr.updateValue(i, forKey: char)
//            }else{
//                marr.updateValue(1, forKey: char)
//            }
        }
        print(marr)
    }
    
    
    func createArray() {
        
        //字符串数组
        var strArr : [String] = ["哈哈","呵呵"]
        var intArr = [Int]()
        intArr.append(3)
        
        //重复元素
        var repeatArr = [String].init(repeating: "哈哈", count: 4)
        let btn = UIButton.init()
        print(repeatArr)
        for str in repeatArr {
            print(Unmanaged.passRetained(str as AnyObject))
            print(btn)
        }
        
        print(intArr)
        print(strArr)
        //数量
        print(strArr.count)
        //检查是否为空
        print(strArr.isEmpty)
        //添加
        strArr.append("哈哈哈")
        strArr += ["呵呵呵"]
        print(strArr)
        
        //下标取值
        print(strArr[0])
        strArr[0] = "egg"
        print(strArr)
        
        //范围下标替换
        strArr[1...3] = ["apple","banana"]
        print(strArr)
        
        //插入
        strArr.insert("orange", at: 1)
        print(strArr)
        
        //删除
        let ele = strArr.remove(at: 1)
        strArr.removeLast()
        print("\(ele)   \(strArr)" )
        
        //数组遍历
        for item in strArr {
            print(item)
        }
        
        for (index,value) in strArr.enumerated() {
            print("\(index)   \(value)")
        }
        
        //数组的拷贝行为
        //一般的赋值，方法传递，数组内容不会被拷贝
        //只有在有可能修改数组长度时数组会产生拷贝行为
        var a = [1,2,3]
        var b = a
        var c = b
        print("a1 = \(a[0])  b1 = \(b[0]) c1 = \(c[0])")
        a[0] = 3
        print("a1 = \(a[0])  b1 = \(b[0]) c1 = \(c[0])")
        
        
        
    }
}
