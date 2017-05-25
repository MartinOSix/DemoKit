//
//  URLImageViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/12.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class URLImageViewController: UIViewController,URLSessionDownloadDelegate {

    let imageURL = "http://c.hiphotos.baidu.com/zhidao/pic/item/5ab5c9ea15ce36d3c704f35538f33a87e950b156.jpg"
    
    let imageV1 = UIImageView.init(frame: CGRect(x: 0, y: 64, width: kScreenWidth/2, height: (kScreenHeight-64)/2-20))
    let imageV2 = UIImageView.init(frame: CGRect(x: kScreenWidth/2, y: 64, width: kScreenWidth/2, height: (kScreenHeight-64)/2-20))
    let imageV3 = UIImageView.init(frame: CGRect(x: 0, y: (kScreenHeight-64)/2, width: kScreenWidth/2, height: (kScreenHeight-64)/2-20))
    let imageV4 = UIImageView.init(frame: CGRect(x: kScreenWidth/2, y: (kScreenHeight-64)/2, width: kScreenWidth/2, height: (kScreenHeight-64)/2-20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(imageV1)
        let normalDownload = UILabel.init(frame: CGRect(x:imageV1.frame.minX , y: imageV1.frame.maxY, width: imageV1.frame.size.width, height: 20))
        normalDownload.text = "普通打开"
        self.view.addSubview(normalDownload)
        self.view.addSubview(imageV2)
        let normalDownload1 = UILabel.init(frame: CGRect(x:imageV2.frame.minX , y: imageV2.frame.maxY, width: imageV2.frame.size.width, height: 20))
        normalDownload1.text = "普通下载"
        self.view.addSubview(normalDownload1)
        self.view.addSubview(imageV3)
        let normalDownload3 = UILabel.init(frame: CGRect(x:imageV3.frame.minX , y: imageV3.frame.maxY, width: imageV3.frame.size.width, height: 20))
        normalDownload3.text = "自定义下载"
        self.view.addSubview(normalDownload3)
        self.view.addSubview(imageV4)
        let normalDownload4 = UILabel.init(frame: CGRect(x:imageV4.frame.minX , y: imageV4.frame.maxY, width: imageV4.frame.size.width, height: 20))
        normalDownload4.text = "带进度下载"
        self.view.addSubview(normalDownload4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let poi = (touches.first!.location(in: self.view))
        if poi.x < kScreenWidth/2 && poi.y<kScreenHeight/2 {
            print("普通打开")
            normalOpen()
        }else if poi.x > kScreenWidth/2 && poi.y<kScreenHeight/2 {
            print("普通下载")
            downImage()
        }else if poi.x < kScreenWidth/2 && poi.y>kScreenHeight/2 {
            print("自定义下载")
            backgroundTask()
        }else{
            print("带进度下载")
            showLoadProgress()
        }
    }
    
    func normalOpen() {
        if let url = URL(string: imageURL){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print("默认读取完毕.线程\(Thread.current)")
                DispatchQueue.main.async {
                    self.imageV1.image = UIImage.init(data: data!)
                }
            }).resume()
        }
    }
    
    func downImage() {
        /*urlsession的task有三种：
         1:dataTask,普通的读取服务端数据操作
         2:downloadTask,下载文件
         3:uploadTask,上传文件
         */
        if let url = URL.init(string: imageURL) {
            URLSession.shared.downloadTask(with: url, completionHandler: { (dowurl, response, error) in
                /*dowurl 是下载好的文件位置（文件临时缓存，需要移动出来）*/
                print("默认下载位置\(dowurl?.path),线程\(Thread.current)");
                DispatchQueue.main.async {
                    do {
                        self.imageV2.image = try UIImage(data: Data(contentsOf: dowurl!))
                    } catch let err as NSError {
                        print("打开文件失败\(err.localizedFailureReason)")
                    }
                }
            }).resume()
        }
    }
    
    /*自定义session：
     init(configuration:)
     init(configuration:delegate:delegateQueue:)
     都需要一个SessionConfiguration对象。该对象有三种初始化方法：
     default:该配置使用全局缓存，cookie等信息
     ephemeral:不会对缓存或cookie以及认证信息进行存储，相当于一个私有session
     background:让网络操作在应用切换到后台后还继续工作
     */
    func backgroundTask() {
        
        if let url = URL.init(string: imageURL) {
            /*URLSessionConfiguration可以进行很多配置，比如timeoutIntervalForRequest、timeoutIntervalForResource控制网络超时时间，allowsCellularAccess:是否可以使用无线网络，HTTPAdditionalHeaders:指定http请求头等*/
            let congfiguration = URLSessionConfiguration.default
            let session = URLSession.init(configuration: congfiguration)
            session.downloadTask(with: url, completionHandler: { (fileurl, response, error) in
                print("自定义下载位置\(fileurl?.path),thread \(Thread.current)")
                DispatchQueue.main.async {
                    do {
                        self.imageV3.image = try UIImage.init(data: Data.init(contentsOf: fileurl!))
                    }catch let error as NSError {
                        print("打开文件失败 \(error.localizedFailureReason)")
                    }
                }
            }).resume()
        }
    }
    
    //使用代理，上面的方法都是采用闭包的方式处理网络完成的情况，如果需要监听网络操作过程中的事件，需要使用代理
    /*sessionDelegate:网络请求最基本的代理方法
     sessionTaskDelegate:请求任务相关的代理方法
     sessionDownloadDelegate:下载任务代理方法，比如进度
     sessionDataDelegate:普通数据和上传任务代理方法
     */
    func showLoadProgress() {
        if let url = URL(string: imageURL) {
            let session = URLSession(configuration: .background(withIdentifier: "download"), delegate: self, delegateQueue: nil)
            session.downloadTask(with: url).resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("下载进度：\(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }
    
    //下载完毕
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("代理下载完毕，位置：\(location.path)。\(Thread.current)")
        DispatchQueue.main.async {
            do {
                self.imageV4.image = try UIImage(data: Data(contentsOf: location))
            }catch let err as NSError {
                print("打开文件失败:\(err.localizedFailureReason)")
            }
        }
    }
    
    //重新下载
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("从\(fileOffset)处恢复下载，一共\(expectedTotalBytes)")
    }
}
