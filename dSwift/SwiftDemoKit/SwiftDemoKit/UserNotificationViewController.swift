//
//  UserNotificationViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import UserNotifications

class UserNotificationViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let content = UNMutableNotificationContent()
        content.title = "本地通知"
        content.subtitle = "本地通知副标题"
        content.body = "通知内容"
        content.badge = NSNumber.init(value: 1)
        content.userInfo = ["abc":"123","haha":"gege"]
        content.sound = UNNotificationSound.default()
        
        var component = DateComponents()
        component.year = 2017
        component.month = 5
        component.day = 31
        component.hour = 15
        component.minute = 6
        
        let date = Calendar.current.date(from: component)
        print("\(date),\(NSDate.init())")
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10, repeats: false)
        //let trigger = UNCalendarNotificationTrigger.init(dateMatching: component, repeats: true)
        
        
        let request = UNNotificationRequest.init(identifier: "ide", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print("send complete")
        }
    }
}


















