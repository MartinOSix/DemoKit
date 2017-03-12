//
//  GameModel.swift
//  2048swift
//
//  Created by runo on 17/3/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import Foundation

protocol GameModelProtocol : class {
    
    func scoreChanged(to score: Int);
    func moveOneTitle(form:(Int,Int),to:(Int,Int),value:Int);
    func moveTwoTitles(form: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int);
    func insertTitle(at location: (Int,Int), withValue value: Int);
    
}
