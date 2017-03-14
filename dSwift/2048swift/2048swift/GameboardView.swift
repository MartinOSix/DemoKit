//
//  GameboardView.swift
//  2048swift
//
//  Created by runo on 17/3/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class GameboardView: UIView {

    var dimension: Int      //每行（列）区块个数
    var tileWidth: CGFloat  //每个小块的宽度
    var tilePadding: CGFloat//每个小块的间距
    var cornerRadius: CGFloat
    var tiles: Dictionary<IndexPath, TitleView>
    
    let provider = AppearanceProvider()
    
    let tilePopStartScale: CGFloat = 0.1
    let tilePopMaxScale: CGFloat = 1.1
    let tilePopDelay: TimeInterval = 0.05
    let tileExpandTime: TimeInterval = 0.18
    let tileContractTime: TimeInterval = 0.08
    
    let tileMergeStartScale: CGFloat = 1.0
    let tileMergeExpandTime: TimeInterval = 0.08
    let tileMergeContractTime: TimeInterval = 0.08
    
    let perSquareSlideDuration: TimeInterval = 0.08
    
    //初始化，background 是区块颜色，foregroundcolor 是小块颜色
    init(dimesion d: Int, tileWidth width: CGFloat, tilePadding padding: CGFloat, cornerRadius radius: CGFloat, backgroundColor: UIColor, foregroundColor: UIColor){
        assert(d>0)
        dimension = d
        tileWidth = width
        tilePadding = padding
        cornerRadius = radius
        tiles = Dictionary()
        let sideLength = padding + CGFloat(dimension)*(width + padding)
        super.init(frame: CGRect(x: 0, y: 0, width: sideLength, height: sideLength))
        layer.cornerRadius = radius
        setupBackground(backgroundColor: backgroundColor, tileColor: foregroundColor)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackground(backgroundColor bgColor: UIColor, tileColor: UIColor) {
        backgroundColor = bgColor
        var xCursor = tilePadding
        var yCursor: CGFloat
        let bgRadius = (cornerRadius >= 2) ? cornerRadius - 2 : 0
        for _ in 0..<dimension {
            yCursor = tilePadding
            for _ in 0..<dimension {
                let background = UIView(frame: CGRect(x: xCursor, y: yCursor, width: tileWidth, height: tileWidth))
                background.layer.cornerRadius = bgRadius
                background.backgroundColor = tileColor
                addSubview(background)
                yCursor += tilePadding + tileWidth
            }
            xCursor += tilePadding + tileWidth
        }
    }
    
    func insertTile(pos : (Int, Int), value :Int) {
        assert(positionIsValied(position: pos))
        let (row, col) = pos
        //取出当前数字块的左上角坐标（相对于游戏区块）
        let x = tilePadding + CGFloat(col)*(tileWidth + tilePadding)
        let y = tilePadding + CGFloat(row)*(tileWidth + tilePadding)

        let tileView = TitleView(position: CGPoint(x: x, y: y), width: tileWidth, value: value, radius: 8, delegate: provider)
        addSubview(tileView)
        bringSubview(toFront: tileView)
        
        tiles[IndexPath(row: row, section: col)] = tileView
        //动画效果
        UIView.animate(withDuration: tileExpandTime, delay: tilePopDelay, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { 
                tileView.layer.setAffineTransform(CGAffineTransform.init().scaledBy(x: self.tilePopMaxScale, y: self.tilePopMaxScale))
            }, completion: {finished in
                UIView.animate(withDuration: self.tileContractTime, animations: { 
                        tileView.layer.setAffineTransform(CGAffineTransform.identity)
                })
        })
        
    }
    
    func positionIsValied(position :(Int, Int)) -> Bool {
        let (x, y) = position
        return x >= 0 && x < dimension && y >= 0 && y < dimension
    }

}






















