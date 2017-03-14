//
//  CQGameViewController.swift
//  2048swift
//
//  Created by runo on 17/3/14.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class CQGameViewController: UIViewController {

    var dimension: Int //空间维度
    var threshold: Int //结束分数
    var gameBorderView: UIView!
    
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    var tileWidht : CGFloat = 0
    
    let gameModel = CQGameModel()
    var tileViewArr : [CQTileView] = [CQTileView]()
    var numberArr: [TileValueEnum] = [TileValueEnum]()
    
    init(dimension d: Int, threshold t: Int){
        dimension = d > 2 ? d:2
        threshold = t > 8 ? t:8
        let leftwidth = screenW - 60.0 - CGFloat((dimension+1)*10)
        tileWidht = leftwidth / CGFloat(dimension)
        super.init(nibName: nil, bundle: nil)
        //tileWidht = screenW - CGFloat(2*30) - CGFloat((dimension+1)*10) / d
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setupGame()
        
    }

    func setupGame() {
        
        gameBorderView = UIView.init(frame: CGRect(x: 30, y: 100, width: screenW-2*30, height: screenW-2*30))
        gameBorderView.backgroundColor = UIColor.white
        gameBorderView.layer.cornerRadius = 5
        view.addSubview(gameBorderView)
        
        setupTileView()
        
        inserTileToEmptyTile(value: 2)
        inserTileToEmptyTile(value: 2)
        setupSwipeControls()
    }
    //添加手势
    func setupSwipeControls() {
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upCommand(gesture:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upCommand(gesture:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upCommand(gesture:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upCommand(gesture:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func upCommand(gesture :UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.up:
            moveByOperation(operation: .TO_UP)
        case UISwipeGestureRecognizerDirection.down:
            moveByOperation(operation: .TO_DOWN)
        case UISwipeGestureRecognizerDirection.left:
            moveByOperation(operation: .TO_LEFT)
        case UISwipeGestureRecognizerDirection.right:
            moveByOperation(operation: .TO_RIGHT)
        default:
            break;
        }
    }

    
    func setupTileView() {
        
        func getOriginBy(poisition :Int) -> CGPoint {
            
            var x:CGFloat = 10;
            var y:CGFloat = 10;
            
            x += CGFloat(poisition%dimension) * (tileWidht+10)
            y += CGFloat(poisition/dimension) * (tileWidht+10)
            return CGPoint(x: x, y: y)
        }
        
        for i in 0..<(dimension * dimension) {
            let poi = getOriginBy(poisition: i)
            let frame = CGRect(origin: poi, size: CGSize(width: tileWidht, height: tileWidht))
            let tileView = CQTileView(frame: frame, Value: .EMPTY)
            tileView.layer.cornerRadius = 5
            tileView.clipsToBounds = true
            tileViewArr.append(tileView)
            numberArr.append(.EMPTY)
            gameBorderView.addSubview(tileView)
        }
    }
    
    func getEmptyPostionTile() -> [Int] {
        
        var emptyArr = [Int]()
        for (index, view) in tileViewArr.enumerated() {
            
            switch view.value {
            case .EMPTY:
                emptyArr.append(index)
            default:
                break
            }
        }
        return emptyArr
    }
    
    func inserTileToEmptyTile(value v:Int) {
        let emptyArr = getEmptyPostionTile()
        if emptyArr.count == 0 {
            print("game over")
            return;
        }
        
        let poi = arc4random_uniform(UInt32(emptyArr.count))
        let vpoi = emptyArr[Int(poi)]
        let tileView: CQTileView = tileViewArr[vpoi]
        tileView.value = TileValueEnum.VALUE(v)
        numberArr[vpoi] = TileValueEnum.VALUE(v)//同步数据
    }
    
    
    
    func moveByOperation(operation :CQOperation) {
        var hasChange = false
        numberArr = gameModel.calculateOperation(Operation: operation, sourceData: numberArr, hasChangeBlock:{ (res :Bool) in
            hasChange = res
        })
        if hasChange {
            reloadData()
            inserTileToEmptyTile(value: 2)
        }
        
    }
    
    func reloadData() {
        
        for (index, value) in numberArr.enumerated() {
            let tileView = tileViewArr[index]
            tileView.value = value
        }
    }

}
