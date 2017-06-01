
//
//  MyCollectionViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

let SectionBackground = "SectionBackground"

class SBCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor = UIColor.clear
}

class SBCollectionReusableView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? SBCollectionViewLayoutAttributes else {
            return
        }
        
        self.backgroundColor = attr.backgroundColor
    }
} 

protocol SBCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
}

class SBCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? SBCollectionViewDelegateFlowLayout
            else {
                return
        }
        
        
        // 1、注册section背景view
        self.register(SBCollectionReusableView.classForCoder(), forDecorationViewOfKind: SectionBackground)
        //清除之前的属性
        self.decorationViewAttrs.removeAll()
        
        //遍历所有的section
        for section in 0..<numberOfSections {
            
            //获取section中的第一个和最后一个item的Attribute
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                    continue
            }
            
            //获取section边距
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            
            //联合，计算出这两个frame所包含的所有位置
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x -= sectionInset.left
            sectionFrame.origin.y -= sectionInset.top
            
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            // 2、定义
            let attr = SBCollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground, with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            self.decorationViewAttrs.append(attr)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        for attr in self.decorationViewAttrs {
            if rect.intersects(attr.frame) {
                // 3、返回
                attrs?.append(attr)
            }
        }
        return attrs
    }
}

class MyCollectionViewController: UIViewController,SBCollectionViewDelegateFlowLayout,UICollectionViewDataSource {


    var collection :UICollectionView? = nil
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let collectionLayout = SBCollectionViewFlowLayout.init()
        
        collectionLayout.itemSize = CGSize.init(width: 50, height: 50)
        collectionLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)//section边界
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.minimumInteritemSpacing = 10
        
        
        
        self.collection = UICollectionView.init(frame: kScreenBounds, collectionViewLayout: collectionLayout)
        self.collection?.backgroundColor = UIColor.white
        self.view.addSubview(self.collection!)
        self.collection?.dataSource = self
        self.collection?.delegate = self
        self.collection?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.backgroundColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.gray
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor{
        switch section {
        case 1:
            return UIColor.red
        default:
            return UIColor.blue
        }
        
    }


}
