//
//  ViewController.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/5.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit
/*
    基本类型
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad() 
        
        //循环
        var res = ""
        for i in 1...10 {
            res.append(String(i))
        }
        print(res)
        
        //遍历数组
        let arr = [1,2,3,4,5,6]
        for i in 0..<arr.count {
            print(arr.index(after: i))
            print(arr[i])
        }
        
        print(self.toZero(x: 10))
        
        //let arr1 = "abcdefg"
        //self.swape(arr3: arr1, p: 0, q: 1)
        //print(arr1)
        print(self.sum(num: 10))
        
        
        
        
        
    }
    
    
    func getChart(str :String) -> Character {
        
        var dic = NSMutableDictionary.init()
        for tmp in str.characters {
        
            
        }
        return "a"
    }
    
    
    func sum(num :Int) ->Int {
        
        if num == 1 {
            return 1
        }
        return num + self.sum(num: num-1)
        
    }
    
    func toZero(x :Int) -> Int {
        var x = x
        while x > 0 {
            x -= 1
        }
        return x
    }
    
    func swape( arr3:inout [Character], p :Int, q :Int) {
        
        let tmp = arr3[p]
        arr3[p] = arr3[q]
        arr3[q] = tmp
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

