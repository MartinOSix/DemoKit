//
//  DanTangViewController.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class DanTangViewController: UIViewController,ChannelTitleViewDelegate {

    var channelView: ChannelTitleView? = nil
    var channelItems: [HomeItemModel]? = nil
    var bottomView: UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        weak var weakSelf = self
        NetworkUtil.sharUtil.loadHomeItemInfo { (items) in
            
            weakSelf?.channelItems = items
            weakSelf?.setUpTitleView()
            weakSelf?.setUpBottomView()
        }
    }
    
    func setUpTitleView() {
        
        var titles = [String]()
        for item in self.channelItems! {
            titles.append(item.name!)
        }
        self.channelView = ChannelTitleView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 30), titles: titles)
        self.view.addSubview((self.channelView!))
        self.channelView?.clickDelegate = self
    }
    
    func setUpBottomView() {
        
        for item in self.channelItems! {
            let topicVC = TopicViewController()
            topicVC.currentChannel = item
            self.addChildViewController(topicVC)
        }
        
        let folowLayout = UICollectionViewFlowLayout()
        folowLayout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight-30-64-44)
        folowLayout.minimumLineSpacing = 0
        folowLayout.minimumInteritemSpacing = 0
        folowLayout.scrollDirection = .horizontal
        
        self.bottomView = UICollectionView.init(frame: CGRect.init(x: 0, y: 30, width: kScreenWidth, height: kScreenHeight-30-64-44), collectionViewLayout: folowLayout)
        self.bottomView?.delegate = self
        self.bottomView?.dataSource = self
        self.bottomView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.bottomView?.isPagingEnabled = true
        self.bottomView?.backgroundColor = UIColor.white
        self.view.addSubview(self.bottomView!)
    }
    
    func channelTitleView(DidSelect Index: Int) {
        print("index \(Index)")
        self.bottomView?.scrollToItem(at: IndexPath.init(item: Index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
}

extension DanTangViewController: UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let currentVC = self.childViewControllers[indexPath.row]
        currentVC.view.frame = cell.contentView.bounds
        //currentVC.view.backgroundColor = UIColor.arcColor()
        cell.contentView.addSubview(currentVC.view)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.x/kScreenWidth
        let currentIndex = Int.init(current)
        self.channelView?.rsetCurrentIndex(At: currentIndex)
    }
    
}
