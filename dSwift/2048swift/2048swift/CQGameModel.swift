//
//  CQGameModel.swift
//  2048swift
//
//  Created by runo on 17/3/14.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import Foundation
import UIKit

enum CQOperation {
    case TO_LEFT
    case TO_UP
    case TO_RIGHT
    case TO_DOWN
}

class CQGameModel: NSObject {
    
    var hasChangeBlock : ((_ result: Bool) -> Void)?
    
    override init() {
        super.init()
    }
    
    func calculateOperation(Operation op: CQOperation, sourceData :[TileValueEnum], hasChangeBlock :@escaping (_ result: Bool)->Void) -> [TileValueEnum] {
        
        self.hasChangeBlock = hasChangeBlock
        switch op {
        case .TO_UP:
            return upOperation(sourceData)
        case .TO_DOWN:
            return downOperation(sourceData)
        case .TO_RIGHT:
            return rightOperation(sourceData)
        case .TO_LEFT:
            return leftOperation(sourceData)
        default:
            break;
        }
        return [TileValueEnum](repeatElement(.EMPTY, count: 4*4))
    }
    
    func leftOperation(_ sourceData :[TileValueEnum]) -> [TileValueEnum] {
        
        var bufferArr = [TileValueEnum](repeatElement(TileValueEnum.EMPTY, count: 4*4))
        for i in 0..<4 {
            
            var inerBuff = [TileValueEnum]()
            for j in 0..<4 {
                inerBuff.append(sourceData[j+i*4])
            }
            for (index, value) in sortSourceData(condenceArr(inerBuff)).enumerated() {
                bufferArr[index+i*4] = value
            }
        }
        return bufferArr
    }
    
    func rightOperation(_ sourceData :[TileValueEnum]) -> [TileValueEnum] {
        
        var bufferArr = [TileValueEnum](repeatElement(TileValueEnum.EMPTY, count: 4*4))
        for i in 0..<4 {
            
            var inerBuff = [TileValueEnum]()
            for j in 0..<4 {
                inerBuff.append(sourceData[(3-j)+i*4])
            }
            for (index, value) in sortSourceData(condenceArr(inerBuff)).enumerated() {
                bufferArr[(3-index)+i*4] = value
            }
        }
        return bufferArr
    }
    
    func downOperation(_ sourceData :[TileValueEnum]) -> [TileValueEnum] {
        
        var bufferArr = [TileValueEnum](repeatElement(TileValueEnum.EMPTY, count: 4*4))
        for i in 0..<4 {
            
            var inerBuff = [TileValueEnum]()
            for j in 0..<4 {
                inerBuff.append(sourceData[(3-j)*4+i])
            }
            for (index, value) in sortSourceData(condenceArr(inerBuff)).enumerated() {
                bufferArr[(3-index)*4+i] = value
            }
        }
        return bufferArr
    }
    
    
    func upOperation(_ sourceData :[TileValueEnum]) -> [TileValueEnum] {
        
        /*
         
         */
        var bufferArr = [TileValueEnum](repeatElement(TileValueEnum.EMPTY, count: 4*4))
        for i in 0..<4 {
            
            var inerBuff = [TileValueEnum]()
            for j in 0..<4 {
                inerBuff.append(sourceData[j*4+i])
            }
            for (index, value) in sortSourceData(condenceArr(inerBuff)).enumerated() {
                bufferArr[index*4+i] = value
            }
        }
        return bufferArr
    }
    
    
    //首先将所有的数字都靠齐
    func condenceArr(_ sourceLineData: [TileValueEnum]) -> [TileValueEnum] {
        
        var bufferArr = [TileValueEnum](repeatElement(TileValueEnum.EMPTY, count: 4))
        var currentIdx = 0
        for (index , valueEnum) in sourceLineData.enumerated() {
            switch valueEnum {
            case .VALUE(_):
                if index != currentIdx {
                    if (hasChangeBlock != nil) {
                        hasChangeBlock!(true)
                    }
                }
                bufferArr[currentIdx] = valueEnum
                currentIdx += 1
            default:break
            }
        }
        return bufferArr
    }
    
    //合并
    func sortSourceData(_ sourceLineData: [TileValueEnum]) -> [TileValueEnum] {
        
        var bufferArr = [TileValueEnum](repeatElement(TileValueEnum.EMPTY, count: 4))
        var currentIndex = 0
        var isbreak = false
        for (index, value) in sourceLineData.enumerated() {
            
            if isbreak {
                isbreak = false
                continue
            }
            switch value {
            case .EMPTY:
                break
            case let TileValueEnum.VALUE(a):
                    
                if (index != 3 && a == sourceLineData[index+1].getValue()) {
                    bufferArr[currentIndex] = TileValueEnum.VALUE(a*2)
                    if (hasChangeBlock != nil) {
                        hasChangeBlock!(true)
                    }
                    isbreak = true
                    currentIndex += 1
                }else{
                    bufferArr[currentIndex] = TileValueEnum.VALUE(a)
                    currentIndex += 1
                }
                
            }
            
        }
        return bufferArr
    }
}
