//
//  CustomTableViewCell.swift
//  SwiftPlayLocalVideo
//
//  Created by runo on 17/3/15.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

protocol CustomTableViewCellDelegate: NSObjectProtocol {
    func playBtnClick(cell: CustomTableViewCell) -> Void;
}

class CustomTableViewCell: UITableViewCell {

    let btn = UIButton(type: UIButtonType.custom)
    let imgV = UIImageView()
    weak var delegate:CustomTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 120)
        contentView.addSubview(imgV)
        
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.center = CGPoint.init(x: UIScreen.main.bounds.size.width/2, y: 45)
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 30
        contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.selectionStyle = .none;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(btn: UIButton) {
        
        if let delegate = self.delegate {
            delegate.playBtnClick(cell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
