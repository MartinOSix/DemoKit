//
//  WodeViewController.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class WodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let pview = ProgressView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        pview.progress = 0.5
        pview.backgroundColor = UIColor.white
        self.view.addSubview(pview)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
