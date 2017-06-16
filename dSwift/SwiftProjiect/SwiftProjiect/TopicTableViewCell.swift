//
//  TopicTableViewCell.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/14.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import Kingfisher

class TopicTableViewCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadItemModel(model :TopicItemModel) {
        
        self.bgImageView.kf.setImage(with: URL.init(string: model.cover_image_url!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        self.titleLabel.text = model.title
    }
    
}
