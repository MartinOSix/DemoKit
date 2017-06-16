//
//  ViewController_enum_Struct_class_protocol.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 16/12/21.
//  Copyright © 2016年 com.runo. All rights reserved.
//

import UIKit

//初始值枚举
enum StudentType : Int{
    case pupil = 10 //小学生
    case middleSchoolStudent = 15 //中学城
    case collegeStudent = 20 //大学生
}

//关联值枚举
enum StudentType2 {
    case pupil(String)
    case middleSchoolStudent(Int,String)
    case collegeStudents(Int,String)
}

//枚举类型
enum CompassPoint: String {
    case North, South, East, West
}

//枚举中的函数
enum Wearable {
    enum Weight: Int {
        case Light = 2
    }
    
    enum Armor: Int {
        case Light = 2
    }
    
    case Helmet(weight: Weight, armor: Armor)
    
    
    func attributes() -> (weight: Int, armor: Int) {
        switch self {
        case .Helmet(let w, let a):
            return (weight: w.rawValue * 2, armor: a.rawValue * 4)
            
        }
    }
}


class ModelT1 {
    var name :String = "name"
    var age :Int = 0
    var height :Float = 1.65
}


//结构体
//所有的结构体都有一个自动生成的成员初始化器，你可以使用它来初始化新结构体实例的成员
//一旦我们自定义了初始化器，系统自动的初始化器就不起作用了,再要就自己写
/*
 值得一提的是在结构体内部方法中如果修改了结构体的成员，那么该方法之前应该加入：mutating关键字。由于结构体是值类型，Swift规定不能直接在结构体的方法（初始化器除外）中修改成员。原因很简单，结构体作为值的一种表现类型怎么能提供改变自己值的方法呢，但是使用mutating我们便可以办到这点，当然这也是和类的不同点。
 */
struct StudentType3 {
    var name: String    //定义结构体成员变量时可以没有初始值
    var mathScore: Int
    var englishScore: Int
    
    init(){
        self.name = "xxx"
        self.mathScore = 100
        self.englishScore = 100
    }
    
    init(name :String, mathScore :Int, englishScore :Int) {
        self.name = name
        self.mathScore = mathScore
        self.englishScore = englishScore
    }
    
    mutating func changeScore(score :Int){
        self.mathScore = score
    }
}

struct StudentScore {
    var chinese: Int
    var math: Int
    var english: Int
}

class ViewController_enum_Struct_class_protocol: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        test_enumeType()
    }
    
    func test_enumeType() {
        
        let n = CompassPoint.North
        print(n.rawValue)
        
        let test = Wearable.Helmet(weight: .Light, armor: .Light).attributes()
        print(test)
        
    }
    
    func test1() {
        let s1 = StudentScore.init(chinese: 10, math: 20, english: 30)
        
        let student1 = StudentType.pupil.rawValue;//rawValue 表示枚举成员的原始值 5
        print(student1)
        
        let student2 = StudentType2.pupil("哈哈哈哈")
        let student3 = StudentType2.middleSchoolStudent(7, "555")
        let student4 = StudentType2.collegeStudents(7, "99999")
        
        switch student3 {
        case .pupil(let str):
            print("pupil  \(str)")
        case .middleSchoolStudent(let day,let str):
            print("middleSchoolStudent \(str) day\(day)")
        default:
            print("not")
        }
        
        
        let student5 = StudentType3.init(name: "liming", mathScore: 90, englishScore: 98)
        print(student5)
        
        var student6 = StudentType3()
        student6.changeScore(score: 10)
        print(student6)
        
        let m1 = ModelT1()
        let m2 = m1
        if m1 === m2 {
            print("同一实例")
        }
        if m1 !== m2 {
            print("不同实例")
        }
    }

}
