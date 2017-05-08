//
//  CollectionDemoViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class CollectionDemoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    let bgImageArr = [#imageLiteral(resourceName: "run"),#imageLiteral(resourceName: "hhhhh"),#imageLiteral(resourceName: "darkvarder"),#imageLiteral(resourceName: "dudu"),#imageLiteral(resourceName: "wave"),#imageLiteral(resourceName: "hello"),#imageLiteral(resourceName: "bodyline")]
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgView = UIImageView.init(frame: self.view.bounds)
        bgView.image = #imageLiteral(resourceName: "blue")
        visualEffectView.frame = kScreenBounds
        bgView.addSubview(visualEffectView)
        self.view.addSubview(bgView)
        
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.itemSize = CGSize.init(width: kScreenWidth-40, height: 200)
        collectionLayout.sectionInset = UIEdgeInsets(top: (kScreenHeight-200)/2, left: 20, bottom: (kScreenHeight-200)/2, right: 20)//section边界
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 40
        collectionLayout.minimumInteritemSpacing = 40
        
        self.collectionView = UICollectionView.init(frame: kScreenBounds, collectionViewLayout: collectionLayout)
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(self.collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bgImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let bgview = cell.backgroundView as? UIImageView {
            bgview.image = self.bgImageArr[indexPath.row]
        }else{
            let imageView = UIImageView.init(frame: cell.bounds)
            cell.backgroundView = imageView
            imageView.image = self.bgImageArr[indexPath.row]
        }
        self .registerForPreviewing(with: self, sourceView: cell.contentView)
        return cell
    }
    
}


extension CollectionDemoViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
            self.showDetailViewController(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return nil;
    }
    
    
    
}
