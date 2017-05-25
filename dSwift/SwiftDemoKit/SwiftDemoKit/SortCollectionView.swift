//
//  SortCollectionView.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

@objc protocol SortCollectionViewDelegate {
    
    @objc optional func beginDragAndInitDragCell(collectionView: SortCollectionView, dragCell: UIView)
    
    @objc optional func endDragAndResetDragCell(collectionView: SortCollectionView, dragCell: UIView)
    
    @objc optional func endDragAndOperateRealCell(collectionView: SortCollectionView, realCell: UICollectionViewCell, isMove: Bool)
    
    @objc optional func exchangeDataSource(fromIndex: IndexPath, toIndex: IndexPath)
    
}

class SortCollectionView: UICollectionView {

    weak var sortableDelegate: SortCollectionViewDelegate?

    var dragView: UIView!//快照
    var originCell: UICollectionViewCell? //要移动的cell
    var timer: Timer?
    
    var fromIndex: IndexPath!
    var toIndex: IndexPath?
    var isMovement = false
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let pan = UILongPressGestureRecognizer(target: self, action: #selector(longGestureHandler(ges:)))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func longGestureHandler(ges: UILongPressGestureRecognizer) {
        //手势点在collectionview的位置
        let collectionViewPoint = ges.location(in: self)
        //手势点在父view的位置
        let superViewPoint = ges.location(in: superview)
        
        //手势按下
        if ges.state == .began {
            //获得点击的cell
            if let index = indexPathForItem(at: collectionViewPoint), let originCell = cellForItem(at: index) {
                beginMoveItemAtIndex(index: index, cell: originCell, viewCenter: superViewPoint)
            }
            
        }else if ges.state == .changed {//手势改变
            updateMoveItem(superPoint: superViewPoint, collectionViewPoint: collectionViewPoint)
            moveItemToPoint(collectionViewPoint)
        }else if ges.state == .ended{
            self.originCell?.isHidden = false
            self.dragView.removeFromSuperview()
        }
    }
    
    func beginMoveItemAtIndex(index: IndexPath, cell: UICollectionViewCell, viewCenter: CGPoint) {
        
        self.originCell = cell
        self.originCell?.isHidden = true
        self.dragView = cell.snapshotView(afterScreenUpdates: false)
        self.dragView.center = CGPoint.init(x: viewCenter.x, y: viewCenter.y)
        self.superview?.addSubview(self.dragView)
    }
    
    func updateMoveItem(superPoint: CGPoint, collectionViewPoint: CGPoint) {
        //移动快照位置
        
        self.dragView.center = superPoint
        moveItemToPoint(collectionViewPoint)
        scrollAtEdge()
    }
    
    func moveItemToPoint(_ collectionViewPoint: CGPoint) {
        if let index = indexPathForItem(at: collectionViewPoint) , let originCell = self.originCell {
            let desCell = cellForItem(at: index)
            if desCell != originCell {
                self.performBatchUpdates({ 
                    if let formIndex = self.indexPath(for: originCell){
                        self.moveItem(at: formIndex, to: index)
                    }
                    }, completion: { (success) in
                        self.toIndex = index
                })
            }
        }
    }
    
    func scrollAtEdge() {
        
        let pinTop = self.dragView.frame.origin.y
        let pinBottom = self.frame.height - (dragView.frame.minY + dragView.frame.height)
        
        var speed:CGFloat = 0
        var isTop = true
        if pinTop < 0 {
            speed = -pinTop
            isTop = true
        }else if pinBottom < 0 {
            speed = -pinBottom
            isTop = false
        }else {
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        
        if let origintimer = self.timer , let originSpeed = (origintimer.userInfo as? [String:AnyObject])?["speed"]as? CGFloat  {
                if abs(speed-originSpeed) > 10 {
                    origintimer.invalidate()
                    let timer = Timer(timeInterval: 1/60.0, target: self, selector: #selector(autoScroll(timer:)), userInfo: ["top":isTop,"speed":speed], repeats: true)
                    self.timer  = timer
                    RunLoop.main.add(timer, forMode: .commonModes)
                }
        } else {
            let timer = Timer(timeInterval: 1/60.0, target: self, selector: #selector(autoScroll(timer:)), userInfo: ["top":isTop,"speed":speed], repeats: true)
            self.timer  = timer
            RunLoop.main.add(timer, forMode: .commonModes)
        }
        
    }
    
    func autoScroll(timer: Timer) {
        if let userinfo = timer.userInfo as? [String:AnyObject] {
            if let top = userinfo["top"] as? Bool, let speed = userinfo["speed"] as? CGFloat{
                let offset = speed/5
                let contentOffset = self.contentOffset
                if top {
                    self.contentOffset.y -= offset
                    self.contentOffset.y = self.contentOffset.y < 0 ? 0 : self.contentOffset.y
                }else {
                    self.contentOffset.y += offset
                    self.contentOffset.y = self.contentOffset.y > self.contentSize.height - self.frame.height ? self.contentSize.height - self.frame.height : self.contentOffset.y
                }
                
                let point = CGPoint(x: dragView.center.x, y: dragView.center.y + contentOffset.y)
                self.moveItemToPoint(point)
            }
        }
    }
    
}





















