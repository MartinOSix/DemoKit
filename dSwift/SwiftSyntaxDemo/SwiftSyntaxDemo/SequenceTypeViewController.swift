//
//  SequenceTypeViewController.swift
//  SwiftSyntaxDemo
//
//  Created by runo on 17/7/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import Foundation

class SequenceTypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}

class CustomeModel {
    
    var values: [Int] = [0,1,2,3,4,5,6,7]
    
}

extension CustomeModel: Sequence {
    
}

