//
//  NumberTitleGameViewController.swift
//  2048swift
//
//  Created by runo on 17/3/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class NumberTitleGameViewController: UIViewController, GameModelProtocol{

    var dimension: Int  //2048 游戏中每行每列含有多少块
    var threshold: Int  //最高分，判断输赢时使用
    var board: GameboardView?
    var model: GameModel?
    
    var scoreView: ScoreViewProtocol?
    let boardWidth: CGFloat = 230.0 //游戏区域的长度和高度
    let thinPadding: CGFloat = 3.0  //游戏区里面小块间的间距
    let thickPadding: CGFloat = 6.0 //
    
    let viewPadding: CGFloat = 10.0
    let verticalViewOffset: CGFloat = 0.0   //初始化高度偏移量
    
    //限制最少是两个块，最低分数为8分，设置整个面板的背景色
    init(dimension d: Int, threshold t: Int) {
        dimension = d > 2 ? d : 2
        threshold = t > 8 ? t : 8
        super.init(nibName: nil, bundle: nil)
        model = GameModel(dimension: dimension, threshold: threshold, delegate: self)
        view.backgroundColor = UIColor(red: 0xE6/255.0, green: 0xE2/255.0, blue: 0xD4/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upCommand(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(upSwipe)
    }
    
    func upCommand(_ r: UIGestureRecognizer!) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }
    
    func setupGame() {
        let vcHeight = view.bounds.size.height
        let vcWidth = view.bounds.size.width
        //获取游戏区域左上角点x的坐标
        func xPositionToCenterView(_ v: UIView) -> CGFloat {
            let viewWidth = v.bounds.size.width
            let tentativeX = 0.5*(vcWidth - viewWidth)
            return tentativeX >= 0 ? tentativeX : 0
        }
        //获取游戏区域左上角y点坐标
        func yPositionForViewAtPosition(_ order: Int, views: [UIView]) -> CGFloat {
            assert(views.count > 0)
            assert(order >= 0 && order < views.count)
            
            let totalHeight = CGFloat(views.count - 1) * viewPadding + views.map({$0.bounds.size.height}).reduce(verticalViewOffset, {$0 + $1})
            let viewsTop = 0.5*(vcHeight - totalHeight) >= 0 ? 0.5 * (vcHeight - totalHeight) : 0
            
            var acc: CGFloat = 0
            for i in 0..<order {
                acc += viewPadding + views[i].bounds.size.height
            }
            return viewsTop + acc
        }
        //获取具体每一个区块的边长
        let width = (boardWidth - thinPadding*CGFloat(dimension + 1))/CGFloat(dimension)
        //初始化一个游戏去对象
        let gamebord = GameboardView(dimesion: dimension,
                                     tileWidth: width,
                                     tilePadding: thinPadding,
                                     cornerRadius: 8,
                                     backgroundColor: UIColor(red: 0x90/255.0, green: 0x8D/255.0, blue: 0x80/255, alpha: 1),
                                    foregroundColor: UIColor(red: 0xF9/255.0, green: 0xF9/255.0, blue: 0xE3/255.0, alpha: 0.5))
        
        //初始化一个计分板
        let scoreView = ScoreView(backgroundColor: UIColor(red : 0xA2/255.0, green : 0x94/255.0, blue : 0x5E/255.0, alpha : 1), textColor: UIColor(red : 0xF3/255, green : 0xF1/255, blue : 0x1A/255, alpha : 0.5), font: UIFont.systemFont(ofSize: 16.0), radius: 8)
        
        let views = [scoreView, gamebord]
        //设置游戏区块在整个面板中的绝对位置，即左上角第一个点
        var f = gamebord.frame
        f.origin.x = xPositionToCenterView(gamebord)
        f.origin.y = yPositionForViewAtPosition(1, views: views)
        gamebord.frame = f
        //将游戏对象加入到当前面板中
        view.addSubview(gamebord)
        board = gamebord
        f = scoreView.frame
        f.origin.x = xPositionToCenterView(scoreView)
        f.origin.y = yPositionForViewAtPosition(0, views: views)
        scoreView.frame = f
        //调用自身方法初始化分数
        scoreView.scoreChange(to: 0)
        view.addSubview(scoreView)
        
        model?.insertRandomPositionTile(value: 2)
        model?.insertRandomPositionTile(value: 2)
        model?.insertRandomPositionTile(value: 2)
    }
    
    func scoreChanged(to score: Int){
        
    }
    func moveOneTitle(form:(Int,Int),to:(Int,Int),value:Int){
        
    }
    func moveTwoTitles(form: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int){
        
    }
    
    func insertTitle(at location: (Int,Int), withValue value: Int){
        assert(board != nil)
        let b = board!
        b.insertTile(pos: location, value: value)
    }
    
    
}
















