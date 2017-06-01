//
//  AppDelegate.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var bgIndetify = UIBackgroundTaskInvalid
    var window: UIWindow?
    let mask = CALayer()
    var timeCount = 0
    var rootNav:MidleNavViewController? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerNotification()
        CCLogSystem.setupDefaultLogConfigure()
        CCLogSystem.makeLog("first \(launchOptions)")
        self.window = UIWindow.init(frame: kScreenBounds)
        self.window?.makeKeyAndVisible()
        self.rootNav = MidleNavViewController.init(rootViewController: ViewController())
        self.window?.rootViewController = self.rootNav
        
        mask.contents = UIImage(named: "twitter")?.cgImage
        mask.contentsGravity = "resizeAspect"
        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: kScreenWidth/2, y: kScreenHeight/2)
        window?.rootViewController?.view.layer.mask = mask
        window?.backgroundColor = UIColor(red: 31/255.0, green: 150/255.0, blue: 1, alpha: 1)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(navClick))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 2
        self.rootNav?.navigationBar .addGestureRecognizer(tap)
        
        animateMask()
        addTouchButton()
        return true
    }

    
    func navClick() {
        CCLogSystem.activeDeveloperUI()
    }
    
    func animateMask() {
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 0.6
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 0.5
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)];
        let firstBounds = NSValue(cgRect: mask.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 300, height: 300))
        let finalBoudns = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1100, height: 1100))
        keyFrameAnimation.values = [firstBounds,secondBounds,finalBoudns];
        keyFrameAnimation.keyTimes = [0,0.8,1]
        //下面两项加起来可以代表动画执行完之后可以不还原
        keyFrameAnimation.fillMode = kCAFillModeForwards
        keyFrameAnimation.isRemovedOnCompletion = false;
        mask.add(keyFrameAnimation, forKey: "bounds")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        window?.rootViewController?.view.layer.mask?.isHidden = true
        window?.rootViewController?.view.layer.mask = nil
    }
    
    //3Dtouch响应
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        CCLogSystem.makeLog("second")
        print(shortcutItem.type)
        if shortcutItem.type.compare("UIApplicationShortcutItemTypeMessage") == ComparisonResult.orderedSame {
            self.rootNav?.pushViewController(CollectionDemoViewController(), animated: true)
        }else if shortcutItem.type.compare("UIApplicationShortcutItemTypePlay") == ComparisonResult.orderedSame {
            self.rootNav?.pushViewController(ShapeLayerAnimationViewController(), animated: true)
        }
    }
    
    //代码添加3DTouch菜单
    func addTouchButton() {
        
        let icon = UIApplicationShortcutIcon(type: .home)
        let item = UIApplicationShortcutItem(type: "main", localizedTitle: "主页", localizedSubtitle: nil, icon: icon, userInfo: nil)
        
        let icon2 = UIApplicationShortcutIcon(templateImageName: "lightning.png")
        let item2 = UIApplicationShortcutItem(type: "secon", localizedTitle: "大海潮", localizedSubtitle: "大海潮", icon: icon2, userInfo: nil)
        
        let icon3 = UIApplicationShortcutIcon(templateImageName: "lightning.png")
        let item3 = UIApplicationShortcutItem(type: "secon", localizedTitle: "小海潮", localizedSubtitle: "小海潮", icon: icon3, userInfo: nil)
        
        UIApplication.shared.shortcutItems?.append(item)
        UIApplication.shared.shortcutItems?.append(item2)
        UIApplication.shared.shortcutItems?.append(item3)
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    //MARK:进入后台任务
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("applicationDidEnterBackground")
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        //进入后台拖延挂起时间任务
        /*
        bgIndetify = application.beginBackgroundTask {
            application.endBackgroundTask(self.bgIndetify)
            self.bgIndetify = UIBackgroundTaskInvalid
        }
        
        DispatchQueue.global().async {
            
            while true {
                
                print("\(self.timeCount)  remaint\(application.backgroundTimeRemaining)")
                sleep(1)
                self.timeCount += 1
            }
        }
         */
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let currentDate = NSDate.init()
        CCLogSystem.makeLog("get currentDate \(currentDate)")
        completionHandler(.newData)
    }
    
    //MARK:ios10通知
    func registerNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (ispermission, error) in
            if ispermission {
                print("授权成功")
            }else{
                print("授权失败 :\(error?.localizedDescription)")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
 
    //前台收到推送
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("收到通知 \(notification.request.content.userInfo)")
        completionHandler(.badge)
    }
    /*
     if UIApplication.shared.canOpenURL(URL.init(string: "dingtalk-open://")!){
     UIApplication.shared.openURL(URL.init(string: "dingtalk-open://")!)
     }
     */
    //后台点击推送
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        CCLogSystem.makeLog("get notification \(NSDate.init())")
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("notification received \(userInfo)")
        completionHandler(.newData)
    }
}


