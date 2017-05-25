//
//  QRCodeViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/5/18.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    let tableview = UITableView.init(frame: kScreenBounds, style: .plain)
    var dataSource = ["扫描二维码","长按识别二维码"]
    var cuurentVersionName: String = "1.0"
    
    func funname(args: Array<String>) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableview)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(QRScanViewController(), animated: true)
        default:
            self.navigationController?.pushViewController(ImageViewController(), animated: true)
            break
        }
    }

}

class QRScanViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession?
    var animationView = UIView.init(frame: CGRect.zero)
    
    func getsession() {
        if let turesession = session {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        //judgeCapture()
        //initScanView()
        setupAnimationView()
    }
    
    func setupAnimationView() {
        
        self.animationView.frame.size = CGSize.init(width: 300, height: 300)
        self.animationView.center = CGPoint.init(x: kScreenWidth/2, y: kScreenHeight/2)
        animationView.layer.borderWidth = 4;
        animationView.layer.borderColor = UIColor.green.cgColor
        self.view.addSubview(animationView)
        
        
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.green.cgColor
        lineLayer.frame = CGRect.init(x: 20, y: 20, width: 260, height: 4)
        self.animationView.layer.addSublayer(lineLayer)
        let baseAnimation = CABasicAnimation.init(keyPath: "position")
        baseAnimation.fromValue = NSValue.init(cgPoint:CGPoint.init(x: 150, y: 20.0))
        baseAnimation.toValue = NSValue.init(cgPoint:CGPoint.init(x: 150, y: 280.0))
        baseAnimation.repeatCount = Float(NSIntegerMax)
        baseAnimation.duration = 2.0
        baseAnimation.repeatDuration = 0.0
        lineLayer.add(baseAnimation, forKey: "anima")
 
        /*//没用
        let lineView = UIView.init(frame: CGRect(x: 20, y: 20, width: 260, height: 4))
        lineView.backgroundColor = UIColor.green
        self.animationView.addSubview(lineView)
        UIView.beginAnimations(nil, context: nil)
        lineView.frame = CGRect(x: 20, y: 280, width: 260, height: 4)
        UIView.setAnimationRepeatCount(Float(NSIntegerMax))
        UIView.setAnimationDuration(6)
        UIView.setAnimationRepeatAutoreverses(true)
        UIView.commitAnimations()
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.session?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session?.stopRunning()
    }
    
    //结果输出
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            let metadata = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            if metadata.stringValue! .hasPrefix("http") {
                UIApplication.shared.openURL(URL.init(string: metadata.stringValue!)!)
                return
            }
            let alert = UIAlertController(title: "扫描结果", message: metadata.stringValue!, preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func initScanView() {
        let layer = AVCaptureVideoPreviewLayer.init(session: session)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer?.frame = kScreenBounds
        view.layer.insertSublayer(layer!, at: 0)
    }
    
    func initSession() {
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)//输入流
            let output = AVCaptureMetadataOutput() //输出流
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //扫描区域
            //let widthS = 300/kScreenHeight
            //let heightS = 300/kScreenWidth
            //output.rectOfInterest = //CGRect(x: (1-widthS)/2, y: (1-heightS)/2, width: widthS, height: heightS)
            session = AVCaptureSession()
            //采集质量
            session?.sessionPreset = AVCaptureSessionPresetHigh
            session?.addInput(input)
            session?.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code]
            
            
        } catch let err as NSError {
            print("位置错误 \(err.localizedFailureReason)")
        }
        
    }
    
    deinit {
        print("\(self.description) 销毁了")
    }
    
    
    //权限判断
    func judgeCapture() {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.notDetermined {//没权限
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (allow) in
                if allow {
                    print("同意")
                }else{
                    print("拒绝")
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
            
        }else if(status == AVAuthorizationStatus.authorized){//被拒绝
            print("有权限")
            initSession()
        }else {
            let alert = UIAlertController.init(title: "提示", message: "请在iPhone的“设置”->“隐私”->“相机”中授权微信访问您的相机", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (act) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

class ImageViewController: UIViewController {
    
    
    let imageView: UIImageView = UIImageView.init(frame: kScreenBounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage.init(named: "IMG_0776")
        self.view .addSubview(imageView)
        
        let ges = UILongPressGestureRecognizer.init(target: self, action: #selector(scanImage))
        self.view.addGestureRecognizer(ges)
    }
    
    
    func scanImage() {
        
        /*CIDetector：iOS自带的识别图片的类*/
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        let arr = detector?.features(in: CIImage(cgImage: (imageView.image?.cgImage)!))
        var detail = ""
        if (arr?.count)! > 0 {
            detail = (arr?.first as! CIQRCodeFeature).messageString!
        }else {
            detail = "未扫描到结果！"
        }
        let alert = UIAlertController(title: "扫描结果", message: detail, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}






















