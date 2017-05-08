//
//  AppDelegate.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/16.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var window: UIWindow?
    let mask = CALayer()
    var rootNav:MidleNavViewController? = nil
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        CCLogSystem.setupDefaultLogConfigure()
        CCLogSystem.makeLog("first")
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
        tap.numberOfTapsRequired = 2
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
        
        let icon2 = UIApplicationShortcutIcon(templateImageName: "darkvarder")
        let item2 = UIApplicationShortcutItem(type: "secon", localizedTitle: "海潮", localizedSubtitle: "小海潮", icon: icon2, userInfo: nil)
        
        UIApplication.shared.shortcutItems?.append(item)
        UIApplication.shared.shortcutItems?.append(item2)
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

