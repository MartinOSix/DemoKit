//
//  DateViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/6/1.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentDate = Date()
        print("currentDate \(currentDate)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = dateFormatter.string(from: currentDate)
        print("date1 \(date1)")
        let timeZone = TimeZone.current.identifier
        print("time Zone \(timeZone)")
        dateFormatter.timeZone = TimeZone.init(identifier: timeZone)
        let date2 = dateFormatter.string(from: currentDate)
        print("date2 \(date2)")
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
