//
//  ViewController_AnyObject.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

class Movie {
    var name:String = ""
    var director:String = ""
    
    init(name:String ,director:String) {
        self.name = name
        self.director = director
    }
    
}

class Human {
    var name:String = ""
    init(name :String) {
        self.name = name
    }
}

class Female: Human {
    var sex = ""
    override init(name :String) {
        super.init(name: name)
        self.sex = "女性"
    }
}

class Male: Human {
    var sex = ""
    override init(name :String) {
        super.init(name: name)
        self.sex = "男性"
    }
}

class ViewController_AnyObject: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //AnyObject 可以代表任何class类型实例
        //Any可以表示任何类型，除了方法类型
        let someObjects:[AnyObject] = [
           Movie.init(name: "2010", director: "stanley"),
           Movie.init(name: "Moon", director: "Duncan"),
           Movie.init(name: "Alien", director: "Ridley")
        ]
        
        for obj in someObjects{
            let movie = obj as! Movie
            print("Movie \(movie.name)  ,dir \(movie.director)")
        }
        
        var things = [Any]()
        things.append(0)
        things.append(0.0)
        things.append(42)
        things.append("hello")
        things.append(Movie.init(name: "name", director: "ivan Reitman"))
        
        print(things)
        
        for thing in things {
            switch thing {
            case 0 as Int:
                print("zero as an Int")
            case 0 as Double :
                print("zero as a Double")
            case let someInt as Int:
                print("integer value of \(someInt)")
            case let moview as Movie:
                print("a movie called \(moview.name)")
            default:
                print("unknow object")
            }
        }
        
        let mans = [
            Male.init(name: "haha"),
            Female.init(name: "songzhixiao"),
            Male.init(name: "guangshu")
        ]
        
        for man in mans {
            
            if man is Male {
                print((man as! Male).sex)
            }
            
            if let val = man as? Female {
                print(val.name)
            }
            
            switch man {
            case let c1 as Male:
                print(c1.name)
            case let c2 as Female:
                print(c2.name)
            default:
                print("error")
            }
        }
    }
}



















