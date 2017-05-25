//
//  CollectionChangePositionViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/15.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class CollectionChangePositionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var collectionView: SortCollectionView!
    var timer: Timer?
    let reuseIdentifier = String(describing: UICollectionViewCell.self)
    var data = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        for _ in 0...40 {
            data.append(UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0))
        }
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.itemSize = CGSize(width: (kScreenWidth-40)/3, height: (kScreenWidth-40)/3)
        collectionLayout.minimumLineSpacing = 5//上下间隔
        collectionLayout.minimumInteritemSpacing = 5//左右间隔
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)//边界
        collectionView = SortCollectionView(frame: kScreenBounds, collectionViewLayout: collectionLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.addSubview(collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = data[indexPath.row]
        return cell
    }

}





















