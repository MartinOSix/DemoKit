//
//  ViewController_genericity.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 17/8/1.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import Foundation

struct User {
    let id: Int
    let name: String
    let email: String
}

enum Either<A,B>{
    
    case Left(A)
    case Right(B)
    
}

class ViewController_genericity: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest.init(url: URL.init(string: "http:127.0.0.1:7878/martinTest")!)
        self.getUser(request: request) { (user) in
            print(user)
        }
        
        self.getUser2(request: request) { (either) in
            switch (either) {
                case let .Left(error):
                    print(error)
                case let .Right(user):
                    print(user)
                
            }
        }
        
        self.getUser3(request: request) { (either) in
            switch (either) {
            case let .Left(error):
                print(error)
            case let .Right(user):
                print(user)
                
            }
        }
        
     
    }
    
    func getUser(request: URLRequest,callBack: @escaping (User)->()) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let trueData = data {
                
                do{
                    let jsonOptional: Any! = try JSONSerialization.jsonObject(with: trueData, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let json = jsonOptional as?  Dictionary<String, AnyObject>{
                        if let id = json["id"] as AnyObject? as? Int {
                            if let name = json["name"] as AnyObject? as? String {
                                if let email = json["email"] as AnyObject? as? String {
                                    let user = User.init(id: id, name: name, email: email)
                                    callBack(user)
                                }
                            }
                        }
                    }
                
                }catch{
                    print("\(error)");
                }
            }
            
            
        }
        task.resume()
    }
    
    //第一次重构  添加错误处理，添加类型别名
    typealias JSON = Any
    typealias JSONDictionary = Dictionary<String,JSON>
    typealias JSONArray = Array<JSON>
    
    
    func getUser2(request: URLRequest, callback: @escaping (Either<Error,User>)-> () ) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let err = error {
                callback(.Left(err))
                return
            }
            
            do{
                let jsonOptional: JSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let json = jsonOptional as? JSONDictionary {
                    
                    if let id = json["id"] as AnyObject? as? Int {
                        if let name = json["name"] as AnyObject? as? String {
                            if let email = json["email"] as AnyObject? as? String {
                                let user = User.init(id: id, name: name, email: email)
                                callback(.Right(user))
                                return
                            }
                        }
                    }
                    
                    
                }
                
                
            }catch{
                callback(.Left(error))
                return
            }
            callback(.Left(NSError.init()))
        }
        task.resume()
    }
    
    //消除多层嵌套
    func JSONString(object: JSON?) -> String? {
        return object as? String
    }
    func JSONInt(object: JSON?) -> Int? {
        return object as? Int
    }
    func JSONObject(object: JSON?) -> JSONDictionary? {
        return object as? JSONDictionary
    }
    
    func getUser3(request: URLRequest, callback: @escaping (Either<Error,User>)-> () ) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let err = error {
                callback(.Left(err))
                return
            }
            
            do{
                let jsonOptional: JSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let json = self.JSONObject(object: jsonOptional) {
                    
                    if let id = self.JSONInt(object: json["id"]) {
                        if let name = self.JSONString(object: json["name"]) {
                            if let email = self.JSONString(object: json["email"]) {
                                let user = User.init(id: id, name: name, email: email)
                                callback(.Right(user))
                                return
                            }
                        }
                    }
                    
                    
                }
                
                
            }catch{
                callback(.Left(error))
                return
            }
            callback(.Left(NSError.init()))
        }
        task.resume()
    }
    
    
    
    

}
