//
//  VideoBackgroundController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation

class VideoBackgroundController: UIViewController {

    let playerVC = AVPlayerViewController()
    let loginBtn = UIButton(type: .custom)
    let regisBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "moments", ofType: "mp4")!)
        playerVC.player = AVPlayer(url: url)    //指定播放源
        playerVC.showsPlaybackControls = false //是否显示工具栏
        playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill//视频画面适应方式
        playerVC.view.frame = kScreenBounds
        playerVC.view.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(repeatPlay), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerVC.player?.currentItem)
        self.view.addSubview(playerVC.view)
        UIView.animate(withDuration: 1) {
            self.playerVC.view.alpha = 1;
            self.playerVC.player?.play()
        }
        
        self.loginBtn.frame = CGRect.init(x: 20, y: kScreenHeight-160, width: kScreenWidth-40, height: 40)
        self.regisBtn.frame = CGRect.init(x: 20, y: kScreenHeight-100, width: kScreenWidth-40, height: 40)
        
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.borderColor = UIColor.white.cgColor
        self.loginBtn.setTitle("login", for: .normal)
        self.loginBtn.layer.cornerRadius = 5
        self.regisBtn.layer.borderWidth = 1
        self.regisBtn.layer.cornerRadius = 5
        self.regisBtn.layer.borderColor = UIColor.white.cgColor
        self.regisBtn.setTitle("regist", for: .normal)
        
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.regisBtn)
    }

    func repeatPlay() {
        playerVC.player?.seek(to: kCMTimeZero)
        playerVC.player?.play()
    }
    
    func loginBtnClick() {
        
        
        
    }
    
}
