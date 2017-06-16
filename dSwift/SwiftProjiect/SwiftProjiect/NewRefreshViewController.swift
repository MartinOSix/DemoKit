//
//  NewRefreshViewController.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/12.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class NewRefreshViewController: UIViewController {

    
    let folowLayout = UICollectionViewFlowLayout()
    let imageArr = [#imageLiteral(resourceName: "walkthrough_1"),#imageLiteral(resourceName: "walkthrough_2"),#imageLiteral(resourceName: "walkthrough_3"),#imageLiteral(resourceName: "walkthrough_4")]
    var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    func setupUI() {
        
        self.folowLayout.itemSize = kScreenBounds.size
        self.folowLayout.minimumLineSpacing = 0
        self.folowLayout.minimumInteritemSpacing = 0
        self.folowLayout.scrollDirection = .horizontal
        self.folowLayout.sectionInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 0, right: 0)
        
        self.collectionView = UICollectionView.init(frame: kScreenBounds, collectionViewLayout: self.folowLayout)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.bounces = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.contentInset = UIEdgeInsets.zero
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
    }
    
    func startBtnClick() {
        self.navigationController?.setViewControllers([MainTabBarViewController()], animated: true)
    }
    
}

extension NewRefreshViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        if let bgimageView = cell.backgroundView as? UIImageView {
            bgimageView.image = imageArr[indexPath.row]
        }else{
            let bgView = UIImageView.init(frame: kScreenBounds)
            bgView.image = imageArr[indexPath.row]
            cell.backgroundView = bgView
        }
        
        if indexPath.row == imageArr.count-1 {
            let start = UIButton(type: .custom)
            start.frame = CGRect.init(x: 0, y: 0, width: 70, height: 30)
            start.layer.borderColor = UIColor.white.cgColor
            start.layer.borderWidth = 1
            start.layer.cornerRadius = 4
            start.center = cell.contentView.center
            start.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
            start.setTitle("start", for: .normal)
            cell.contentView.addSubview(start)
        }
        
        return cell
    }
}
