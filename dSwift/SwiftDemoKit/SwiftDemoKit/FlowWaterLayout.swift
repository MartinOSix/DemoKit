//
//  FlowWaterLayout.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

protocol CustomWaterFallLayoutDelegate: NSObjectProtocol {
    func heightForItemAtIndexPath(indexPath: IndexPath) -> CGFloat
}


class FlowWaterLayout: UICollectionViewFlowLayout {

    //列
    var numberOfColums = 0 {
        didSet {
            for _ in 0..<numberOfColums {
                maxYOfColums.append(0)
            }
        }
    }
    //间隙
    var itemSpace: CGFloat = 5
    weak var delegate: CustomWaterFallLayoutDelegate?
    //缓存
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var maxYOfColums = [CGFloat]()
    private var oldScreenWidth: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        layoutAttributes = computeLayoutAttributes()
        oldScreenWidth = kScreenWidth
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize.init(width: 0, height: maxYOfColums.max()!)
    }
    
    //计算所有UICollectionViewLayoutAttributes
    func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        let totalNums = collectionView!.numberOfItems(inSection: 0)
        let width = (collectionView!.bounds.width - itemSpace * CGFloat(numberOfColums + 1))/CGFloat(numberOfColums)
        
        var x: CGFloat
        var y: CGFloat
        var height: CGFloat
        var currentColum: Int
        var indexPath: IndexPath
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        guard let unwapDelegate = delegate else {
            assert(false, "一定要设置代理")
            return attributesArr
        }
        
        for index in 0..<numberOfColums {
            self.maxYOfColums[index] = 0
        }
        
        for currentIndex in 0..<totalNums {
            
            indexPath = IndexPath.init(row: currentIndex, section: 0)
            height = unwapDelegate.heightForItemAtIndexPath(indexPath: indexPath)
            
            if currentIndex < numberOfColums {
                currentColum = currentIndex
            }else {
                let minMaxY = maxYOfColums.min()!
                currentColum = maxYOfColums.index(of: minMaxY)!
            }
            
            x = itemSpace + CGFloat(currentColum) * (width + itemSpace)
            y = itemSpace + maxYOfColums[currentColum]
            
            maxYOfColums[currentColum] = y + height
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            attributesArr.append(attributes)
            
        }
        return attributesArr
    }
    
}






















