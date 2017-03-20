//
//  ViewController.swift
//  SwiftPlayLocalVideo
//
//  Created by runo on 17/3/15.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomTableViewCellDelegate {

    
    let tableView = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
    var playView: AVPlayer?
    var playViewController: AVPlayerViewController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? CustomTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        (cell as! CustomTableViewCell).delegate = self
        return cell
    }
    
    func playBtnClick(cell: CustomTableViewCell) {
        
        let indexpath = tableView.indexPath(for: cell)
        print("row \(indexpath?.row)")
        let path = Bundle.main.path(forResource: "emoji", ofType: "mp4")
        if path == nil {
            print("找不到文件")
            return
        }
        playView = AVPlayer(url: URL(fileURLWithPath: path!))
        playViewController = AVPlayerViewController()
        playViewController?.player = playView
        self.present(playViewController!, animated: true) { 
            self.playView?.play()
        }
        
        
    }
    

}

