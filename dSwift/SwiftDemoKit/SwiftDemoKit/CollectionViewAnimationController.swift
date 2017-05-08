//
//  CollectionViewAnimationController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/5.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class CollectionViewAnimationController: UIViewController {

    var collectionView: UICollectionView?
    let dataSource = CellModel.getData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = [.bottom,.left,.right]
        self.navigationController?.navigationBar.isTranslucent = false
        let collectoinLayout = UICollectionViewFlowLayout()
        collectoinLayout.scrollDirection = .vertical
        collectoinLayout.itemSize = CGSize(width: kScreenWidth-20, height: 140)
        collectoinLayout.minimumLineSpacing = 10
        collectoinLayout.minimumInteritemSpacing = 10
        collectoinLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView = UICollectionView(frame: kScreenBounds, collectionViewLayout: collectoinLayout)
        collectionView?.backgroundColor = UIColor.orange
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(CollectionViewAnimationCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView!)
        
    }
}

extension CollectionViewAnimationController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath);
        (cell as! CollectionViewAnimationCell).preparaCell(model: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !collectionView.isScrollEnabled {
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewAnimationCell else {
            return
        }
        
        collectionView.isScrollEnabled = false
        cell.handleCellSelected()
        cell.backBtnClickBlock = {
            collectionView.isScrollEnabled = true
            collectionView.reloadItems(at: [indexPath])
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: { 
            cell.frame = CGRect(x: 0, y: (self.collectionView?.contentOffset.y)!, width: kScreenWidth, height: kScreenHeight)
            }) { (finish) in
                print("animation end")
        }
        
    }
    
}

class CellModel {
    var img: UIImage?
    var title: String?
    
    init(Image: UIImage, title: String) {
        img = Image
        self.title = title
    }
    
    static func getData() -> [CellModel] {
        let Img = [#imageLiteral(resourceName: "blue"),#imageLiteral(resourceName: "bodyline"),#imageLiteral(resourceName: "dudu"),#imageLiteral(resourceName: "hello"),#imageLiteral(resourceName: "hhhhh"),#imageLiteral(resourceName: "run")];
        var result = [CellModel]()
        for i in 0..<20 {
            result.append(CellModel(Image: Img[i%6], title: "aqwopieruqpowierjasdlkfj"))
        }
        return result
    }
}


















