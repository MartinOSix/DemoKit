//
//  ViewController.swift
//  JavaScriptCoreDemo
//
//  Created by runo on 17/7/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import JavaScriptCore
import ExternalAccessory

let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    let eaManager = EAAccessoryManager.shared()
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.frame = kScreenBounds
        self.view.addSubview(label)
        eaManager.registerForLocalNotifications()
        //EAAccessoryDidConnect
        
        DispatchQueue.global().async {
            
            let connectAcc = self.eaManager.connectedAccessories;
            var infoStr = "info: "
            
            for  ea in connectAcc {
                for pro in ea.protocolStrings{
                    
                    infoStr.append("protocolStr=\(pro)\n")
                }
                infoStr.append("manufacturer=\(ea.manufacturer)")
                infoStr.append("name=\(ea.name)")
                infoStr.append("modelNumber=\(ea.modelNumber)")
                infoStr.append("serialNumber=\(ea.serialNumber)")
                infoStr.append("firmwareRevision=\(ea.firmwareRevision)")
                infoStr.append("hardwareRevision=\(ea.hardwareRevision)")
                infoStr.append("dockType=\(ea.dockType)")
            }
            print(infoStr)
            DispatchQueue.main.async {
                self.label.text = infoStr
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getConnect), name: NSNotification.Name.init("EAAccessoryDidConnect"), object: nil)
        
    }
    
    func getConnect() {
        
        DispatchQueue.global().async {
            
            let connectAcc = self.eaManager.connectedAccessories;
            var infoStr = "info: "
            
            for  ea in connectAcc {
                for pro in ea.protocolStrings{
                    infoStr.append("protocolStr=\(pro)\n")
                }
                infoStr.append("manufacturer=\(ea.manufacturer)")
                infoStr.append("name=\(ea.name)")
                infoStr.append("modelNumber=\(ea.modelNumber)")
                infoStr.append("serialNumber=\(ea.serialNumber)")
                infoStr.append("firmwareRevision=\(ea.firmwareRevision)")
                infoStr.append("hardwareRevision=\(ea.hardwareRevision)")
                infoStr.append("dockType=\(ea.dockType)")
            }
            print(infoStr)
            DispatchQueue.main.async {
                self.label.text = infoStr
            }
        }
        self.view.backgroundColor = UIColor.red;
    }
    
    func test() {
        //self.swiftUseJSFun()
        //self.swiftUseJS()
        //self.jsCallBlock()
        //安全性理解
        let person: [String: String] = ["name":"haha"]
        print(type(of: person["name"]))
        
        
        let users:[String] = ["haha","haha1","haha2"]
        print(type(of: users[2]))
    }
    
    func swiftUseJSFun() {
        
        let jsCode = "function hello(say){ return say+\"abc\"; }"
        let jsContext = JSContext.init()
        
        _ = jsContext?.evaluateScript(jsCode)
        let jsFun = jsContext?.objectForKeyedSubscript("hello")
        let jsvalue = jsFun?.call(withArguments: ["1234"])
        print(jsvalue)
    }
    
    func swiftUseJS() {
        
        let jsCode = "var num = \"this is js code\""
        let jsContext = JSContext()
        
        _ = jsContext?.evaluateScript(jsCode)
        let jsValue = jsContext?.objectForKeyedSubscript("num")
        print(jsValue)
    }

    func jsCallBlock() {
        
        
        let jsCtx = JSContext()
        let swiftClosure:(@convention(block) (String) -> Void)? = {
            (abc: String)->Void in {
                print("这是\(abc) 写的方法")
            }()
        }
        let swiftAnyObject = unsafeBitCast(swiftClosure, to: AnyObject.self)
        //将swift闭包转换成js
        jsCtx?.setObject(swiftAnyObject, forKeyedSubscript: "eat" as (NSCopying & NSObjectProtocol)!)
        
        //使用js的方式调用闭包方法
        let jsvalue = jsCtx?.objectForKeyedSubscript("eat")
        _ = jsvalue?.call(withArguments: ["嘎嘎嘎"])
        
    }

}

