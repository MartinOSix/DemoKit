//
//  UserNotificationViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/27.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import UserNotifications

let postTestName = "postTestName"

class UserNotificationViewController: UIViewController {
    
    
    let dataSource = ["本地通知","通知中心通知"]
    
    let tableView:UITableView = {
       let tableView = UITableView.init(frame: kScreenBounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        //本机先注册自己的
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(notif:)), name: NSNotification.Name.init(postTestName), object: nil)
        
    }
    
    func getNotification(notif :Notification) {
        print("get notification \(notif)")
    }
    
    func localNotification() {
        
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
    
    func notificationCenter() {
        let not = Notification.init(name: Notification.Name.init(postTestName), object: nil, userInfo: ["name":"haha"])
        NotificationCenter.default.post(not)
    }
    
    
    
}


extension UserNotificationViewController :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            localNotification()
        case 1:
            notificationCenter()
        default:
            break
        }
    }
    
}

















