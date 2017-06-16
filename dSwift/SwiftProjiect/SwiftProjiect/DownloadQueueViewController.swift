
//
//  DownloadQueueViewController.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/12.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class DownloadQueueViewController: UIViewController {

    
    let queuq = OperationQueue.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.queuq.isSuspended = true
        self.queuq.maxConcurrentOperationCount = 1
        for i in 0...100 {
            self.queuq.addOperation {
            print("task \(i) : \(Thread.current)")
            }
        }
        
        
        
    }

    @IBAction func btnclick(_ sender: AnyObject) {
        
        self.queuq.isSuspended = false
    }
  
}
