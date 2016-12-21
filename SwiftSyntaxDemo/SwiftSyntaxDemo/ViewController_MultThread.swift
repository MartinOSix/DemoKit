//
//  ViewController_MultThread.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/15.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

class ViewController_MultThread: UIViewController {

    var label : UILabel? = nil
    let queue = DispatchQueue(label: "wift.queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let labe = UILabel.init(frame: CGRect.init(x: 0, y: 100, width: 100, height: 100))
        label = labe
        self.view.addSubview(labe)
        
        self.function1()
        print("这句话最先打印")
        self.function2()
        self.function3()
        //self.function4()
        self.function5()
    }
    
    //异步操作
    func function1() {
        
        DispatchQueue.global().async {
            sleep(10)
            DispatchQueue.main.async {
                self.label?.backgroundColor = UIColor.red
            }
        }
    }


    
    //Dispatch workItem  将异步任务封装成一个Item
    func function2() {
        let workItem = DispatchWorkItem(qos: .userInitiated, flags: .assignCurrentContext) {
            sleep(10);
            print("aaaa")
        }
        queue.async(execute: workItem)
        print("1234")
    }
    
    //延时执行
    func function3() {
        let delay = DispatchTime.now() + DispatchTimeInterval.seconds(15)
        DispatchQueue.main.asyncAfter(deadline: delay) { 
            self.label?.backgroundColor = UIColor.blue
            print("hhhh")
        }
    }
    
    //线程与任务的关系
    func function4() {
        
        let asyQueue = DispatchQueue.global()
        let sysQueue = DispatchQueue.init(label: "串行")
        print("thread  \(Thread.current)")
        
        if false {
            
            asyQueue.async {
                for _ in 1...10 {
                    print("一部队列异步任务1")
                }
                print("thread  \(Thread.current)")
            }
            asyQueue.async {
                for _ in 1...10 {
                    print("一部队列异步任务2")
                }
                print("thread  \(Thread.current)")
            }
        }
        //结果 交叉运行  不阻塞主线程  开启新线程
        
        print("-------------")
        
        asyQueue.sync {
            for _ in 1...10 {
                print("并发队列同步任务1")
            }
            print("thread  \(Thread.current)")
        }
        
        asyQueue.sync {
            for _ in 1...10 {
                print("并发队列同步任务2")
            }
            print("thread  \(Thread.current)")
        }
        
        print("----end---")
        //顺序执行 阻塞主线程  不开启新线程
        
        
        
        print("---------start------")
        sysQueue.async {
            for _ in 1...10 {
                print("同步队列异步任务1")
            }
            print("thread  \(Thread.current)")
        }
        print("---------midle------")
        sysQueue.async {
            for _ in 1...10 {
                print("同步队列异步任务2")
            }
            print("thread  \(Thread.current)")
        }
        print("---------end------")
        //任务按照顺序执行，但是不会阻塞主线程  开启新线程
        
        
        sysQueue.sync {
            for _ in 1...10 {
                print("同步队列同步任务1")
            }
            print("thread  \(Thread.current)")
        }
        sysQueue.sync {
            for _ in 1...10 {
                print("同步队列同步任务2")
            }
            print("thread  \(Thread.current)")
        }
        print("串行队列同步任务----end")
        //顺序执行，阻塞主线程，不开启新线程
    }
    
    
    //线程同步  （串行队列，异步任务是一个方案）
    func function5() {
        
        let group = DispatchGroup.init()
        group.enter()
        DispatchQueue.global().async {
            print("任务1 开始执行")
            sleep(10)
            print("任务1 结束执行")
            group.leave()
        }
        
        
        group.enter()
        DispatchQueue.global().async {
            print("任务2 开始执行")
            sleep(5)
            print("任务2 结束执行")
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { 
            
            print("最终结果")
            
        }
        
        
    }
    
}
