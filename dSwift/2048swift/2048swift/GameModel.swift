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

class GameModel : NSObject {
    
    let dimension : Int
    let threshold : Int
    
    unowned let delegate : GameModelProtocol
    //存放数字块状态信息
    var gameboard: SquareGameboard<TileObject>
    
    var queue: [MoveCommand]
    var timer: Timer
    
    let maxCommands = 100
    let queueDelay = 0.3
    //当前分数
    var score : Int = 0 {
        didSet {
            delegate.scoreChanged(to: score)
        }
    }
    //初始化一个都存empty的squenceGambord
    init(dimension d: Int, threshold t: Int, delegate: GameModelProtocol) {
        dimension = d;
        threshold = t;
        self.delegate = delegate
        queue = [MoveCommand]()
        timer = Timer()
        gameboard = SquareGameboard(dimension: d, initialValue: .empty)
        super.init()
    }
    
    //获取空的区块位置
    func getEmptyPosition() -> [(Int, Int)] {
        var emptyArrys : [(Int, Int)] = []
        for i in 0..<dimension{
            for j in 0..<dimension {
                if case .empty = gameboard[i,j] {
                    emptyArrys.append((i, j))
                }
            }
        }
        return emptyArrys
    }
    
    //随机在空位置上插入
    func insertRandomPositionTile(value : Int) {
        let emptyArrays = getEmptyPosition()
        if emptyArrays.isEmpty {
            return
        }
        let randompos = Int(arc4random_uniform(UInt32(emptyArrays.count-1)))
        let (x, y) = emptyArrays[randompos]
        gameboard[(x, y)] = .tile(value)
        delegate.insertTitle(at: (x, y), withValue: value)
    }
    
    class func quiescentTileStillQuiescent(inputPosition: Int, outputLength: Int, originalPosition: Int)-> Bool {
        return (inputPosition == outputLength) && (originalPosition == inputPosition)
    }
    
    func queueMove(direction: MoveDirection, onCompletion: @escaping (Bool)->()) {
        guard queue.count <= maxCommands else {
            return
        }
        queue.append(MoveCommand(direction: direction,completion:onCompletion))
        if !timer.isValid {
            timerFired(timer)
        }
    }
    
    func timerFired(_:Timer) {
        if queue.count == 0 {
            return
        }
        var changed = false
        while queue.count > 0 {
            let command = queue[0]
            queue.remove(at: 0)
            
        }
    }
    
        
    
}


















