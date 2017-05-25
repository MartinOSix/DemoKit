//
//  ViewController.swift
//  CocoaPodsDemo
//
//  Created by runo on 17/5/17.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController,FMMosaicLayoutDelegate {

    var collectionView: UICollectionView!
    let HeaderFooterHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = FMMosaicLayout.init()
        layout.delegate = self
        self.collectionView = UICollectionView.init(frame: kScreenBounds, collectionViewLayout: layout)
        self.view .addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
        
        URLSession.init(configuration: URLSessionConfiguration.default).dataTask(with: URL.init(string: "http://ip.taobao.com/service/getIpInfo2.php?ip=myip")!) { (data, respon, error) in
            
            
            do {
                let obj = try JSONSerialization.jsonObject(with: data!, options:  JSONSerialization.ReadingOptions.mutableContainers)
                let sub = (obj as! NSDictionary)["data"]
                 print((sub as! NSDictionary).allValues)
            } catch let err as NSError {
                
            }
            
            
        }.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, numberOfColumnsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, mosaicCellSizeForItemAt indexPath: IndexPath!) -> FMMosaicCellSize {
        return (indexPath.item % 12 == 0) ? FMMosaicCellSize.big : FMMosaicCellSize.small
    }
    
    //分区内边距
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    //分区间隔
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //头高
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderFooterHeight
    }
    
    //尾高
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, heightForFooterInSection section: Int) -> CGFloat {
        return HeaderFooterHeight
    }
    
    //控制分区头尾是否在collectionview之上
    func headerShouldOverlayContent(in collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        return true
    }
    
    func footerShouldOverlayContent(in collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        return true
    }
    
    
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        //cell.backgroundColor = UIColor.init(red: CGFont(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: CGFloat(drand48()))
        
        return cell
    }
}

