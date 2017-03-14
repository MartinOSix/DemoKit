//
//  AuxiliaryModels.swift
//  2048swift
//
//  Created by runo on 17/3/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import Foundation

//用于存放数字块的移动状态，是否需要移动以及两个一块喝并移动等等，关键数据是数组中位置以及最新数字快的值
enum ActionToken {
    case noAction(source: Int, value: Int)
    case move(source: Int, value: Int)
    case singleCombine(source: Int, value: Int)
    case doubleCombine(source: Int, second: Int, value: Int)
    
    func getValue() -> Int {
        switch self {
        case let .noAction(_, v): return v
        case let .move(_, v): return v
        case let .singleCombine(_, v): return v
        case let .doubleCombine(_, _, v): return v
        }
    }
    
    func getSource() -> Int {
        switch self {
        case let .noAction(s, _): return s
        case let .move(s, _): return s
        case let .singleCombine(s, _): return s
        case let .doubleCombine(s, _, _): return s
        }
    }
    
}


//用户操作---- 上下左右
enum MoveDirection {
    case up, down, left, right
}


struct MoveCommand {
    let direction: MoveDirection
    let completion: (Bool) -> ()
}

//最终移动数据封装，标注了所有需要移动的块的原位置及新位置，以及块的最新值
enum MoveOrder {
    case singleMoveOrder(source: Int, destination: Int, value: Int, wasMerge: Bool)
    case doubleMoveOrder(firstSource: Int, secondSource: Int, destination: Int, value: Int)
}

//数组中存放的枚举，要么为空，要么带值的title
enum TileObject {
    case empty
    case tile(Int)
}

struct SquareGameboard<T> {
    let dimension : Int
    //存放实际值的数组
    var boarArray : [T]
    
    init(dimension d: Int, initialValue: T) {
        dimension = d
        boarArray = [T](repeating: initialValue, count: d*d)
    }
    //通过当前的x，y坐标来计算存储和取出的TileObject枚举
    subscript(row: Int, col: Int)-> T {
        get{
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return boarArray[row*dimension + col]
        }
        set {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            boarArray[row*dimension + col] = newValue
        }
    }
    
    //初始化时使用
    mutating func setAll(value : T) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                self[i , j] = value
            }
        }
    }
    
    
}


func merge(group :[TileObject]) -> [MoveOrder] {
    return [MoveOrder]();
}

//去空， 如  | | |2|2| => |2|2| | |
func condense(group : [TileObject]) -> [ActionToken] {
    
    var buffer = [ActionToken]()
    for (index , tile) in group.enumerated(){
        switch tile {
        case let .tile(value) where buffer.count == index:
            buffer.append(ActionToken.noAction(source: index, value: value))
        case let .tile(value) :
            buffer.append(ActionToken.move(source: index, value: value))
        default:break
        }
    }
    return buffer
}

//合并相同的

func collapse(group : [ActionToken]) -> [ActionToken] {
    var tokenBuffer = [ActionToken]()
    //是否跳过下一个，如果把下一个块合过来则跳过下一个
    var skipNext = false
    for (idx, token) in group.enumerated(){
        if(skipNext){
            skipNext = false;
            continue
        }
        switch token {
        //当前块和下一个块值相同，且当前块不需要移动，那么要将下一个块合并到当前块中
        case let ActionToken.noAction(source: s, value: v) where (idx < group.count-1 && v == group[idx+1].getValue() && GameModel.quiescentTileStillQuiescent(inputPosition: idx, outputLength: tokenBuffer.count, originalPosition: s)):
            let next = group[idx + 1]
            let nv = v + group[idx + 1].getValue()
            skipNext = true
            tokenBuffer.append(ActionToken.singleCombine(source: next.getSource(), value: nv))
        //当前块和下一块的值相同，且两个块都需要移动，则将两个块移动到新位置
        case let t where (idx < group.count - 1 && t.getValue() == group[idx + 1].getValue()):
            let next = group[idx + 1]
            let nv = t.getValue() + group[idx + 1].getValue()
            skipNext = true
            tokenBuffer.append(ActionToken.doubleCombine(source: t.getSource(), second: next.getSource(), value: nv))
        //上一步判定不要要移动，但是之前的块有合并过，所以需要移动
        case let ActionToken.noAction(source: s, value: v) where !GameModel.quiescentTileStillQuiescent(inputPosition: idx, outputLength: tokenBuffer.count, originalPosition: s):
            tokenBuffer.append(ActionToken.move(source: s, value: v))
        //上一步判定不需要移动，且之前的块也没有合并，则不需要移动
        case let ActionToken.noAction(source: s, value: v):
            tokenBuffer.append(ActionToken.noAction(source: s, value: v))
        //上一步判定需要移动且不符合上面的条件的，则继续保持移动
        case let ActionToken.move(source: s, value: v):
            tokenBuffer.append(ActionToken.move(source: s, value: v))
        default:
            break
        }
    }
    return tokenBuffer
}

//转换为 moveOrder
func convert(group : [ActionToken]) -> [MoveOrder] {
    var buffer = [MoveOrder]()
    for (idx, tileaction) in group.enumerated() {
        switch tileaction {
        case let ActionToken.move(source: s, value: v):
            //单纯将一个块由s位置移动到idx 位置，新值为v
            buffer.append(MoveOrder.singleMoveOrder(source: s, destination: idx, value: v, wasMerge: false))
        case let ActionToken.singleCombine(source: s, value: v):
            //将s和d两个数字块移动到idx位置,且idx位置有数字块，进行合并，新值为v
            buffer.append(MoveOrder.singleMoveOrder(source: s, destination: idx, value: v, wasMerge: true))
        case let ActionToken.doubleCombine(source: s, second: d, value: v):
            //将s和d两个数字块移动到idx位置并进行合并，新值为v
            buffer.append(MoveOrder.doubleMoveOrder(firstSource: s, secondSource: d, destination: idx, value: v))
        default:
            break
        }
    }
    return buffer
}




















