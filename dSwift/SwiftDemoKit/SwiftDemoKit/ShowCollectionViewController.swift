//
//  ShowCollectionViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ShowCollectionViewController: UIViewController,CustomWaterFallLayoutDelegate {

    var style: String!
    var collectionView: UICollectionView!
    var reuseIdentifier = "cell"
    var cellCount = 0
    var cellHeight = [CGFloat]()
    var lineDataSource = [UIColor.red,UIColor.blue,UIColor.yellow,UIColor.brown,UIColor.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = true
        collectionView = UICollectionView(frame: kScreenBounds, collectionViewLayout: UICollectionViewLayout())
        switch style {
        case "line":
            setLineLayout()
            cellCount = lineDataSource.count
        case "waterfall":
            let layout = FlowWaterLayout()
            layout.delegate = self
            layout.numberOfColums = 4
            cellCount = 100
            collectionView.contentInset = UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0)
            for _ in 0..<self.cellCount {
                cellHeight.append(CGFloat(arc4random()%150 + 30))
            }
            collectionView.collectionViewLayout = layout
        default:
            
            break
            
        }
        
    
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    func heightForItemAtIndexPath(indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }

    func setLineLayout() {
        let layout = LinerLayout()
        layout.itemSize = CGSize.init(width: kScreenWidth-80, height: kScreenHeight-100)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 84, left: 40, bottom: 0, right: 40)
        //collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = layout
    }
    
}

extension ShowCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = lineDataSource[indexPath.row%5]
        return cell
    }
    
}


















