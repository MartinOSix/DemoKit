//: Playground - noun: a place where people can play

import UIKit

public class TestA {
    public let name = "testAname"
    private let age = "nan"
}

class TestB : TestA {
    
}

let a = TestA()
print(a.name)
let b = TestB()
print(b.name)
