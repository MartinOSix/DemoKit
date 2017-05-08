//
//  CollectionViewAnimationCell.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/5.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class CollectionViewAnimationCell: UICollectionViewCell {
    
    
    let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth-20, height: 100))
    let textV = UITextView(frame: CGRect(x: 0, y: 110, width: kScreenWidth-20, height: 30))
    let backBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
    
    var backBtnClickBlock: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageV.contentMode = .center
        imageV.clipsToBounds = true
        textV.font = UIFont.systemFont(ofSize: 14)
        textV.isUserInteractionEnabled = false
        backBtn.setImage(#imageLiteral(resourceName: "Back-icon"), for: .normal)
        backBtn.isHidden = true
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        backgroundColor = UIColor.gray
        
        addSubview(imageV)
        addSubview(textV)
        addSubview(backBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleCellSelected() {
        backBtn.isHidden = false
        superview?.bringSubview(toFront: self)
    }
    
    func backBtnClick() {
        backBtn.isHidden = true
        backBtnClickBlock!()
    }
    
    func preparaCell(model : CellModel) {
        
        imageV.frame = CGRect(x: 0, y: 0, width: kScreenWidth-20, height: 100)
        textV.frame = CGRect(x: 0, y: 110, width: kScreenWidth-20, height: 30)
        
        imageV.image = model.img
        textV.text = model.title
    }
    
}
















