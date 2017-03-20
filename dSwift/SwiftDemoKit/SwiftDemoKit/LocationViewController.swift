//
//  LocationViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/17.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    let button = UIButton(type: .custom)
    let label = UILabel(frame: CGRect.zero)
    let locationManager = CLLocationManager.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//定位精度
        locationManager.requestAlwaysAuthorization()//
        
        self.view.layer.contents = #imageLiteral(resourceName: "blue").cgImage
        
        //添加毛玻璃
        let visual = UIVisualEffectView(effect: UIBlurEffect.init(style: UIBlurEffectStyle.light))
        visual.frame = kScreenBounds
        
        label.frame = CGRect.init(x: 20, y: 100, width: kScreenWidth-40, height: 30)
        label.textAlignment = .center
        label.text = "未定位"
        
        button.frame = CGRect.init(x: 20, y: 150, width: kScreenWidth-40, height: 30)
        button.setTitle("get location", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        
        view.addSubview(visual)
        view.addSubview(button)
        view.addSubview(label)
    }
    
    func btnclick() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
            getAuthority()
            return
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func getAuthority() {
        
        let alert = UIAlertController.init(title: "未获取到定位权限", message: "是否前往设置开通权限", preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            
            if let url = URL.init(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let noAction = UIAlertAction.init(title: "取消", style: .destructive, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*-- locationMangerDelegate --*/
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("didVisit")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        label.text = "\(error.localizedDescription)"
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStartMonitoringFor")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations)")
        if let clo = locations.first {
            label.text = "latitude \(clo.coordinate.latitude)  longtitude \(clo.coordinate.longitude)"
            label.adjustsFontSizeToFitWidth = true
        }
        locationManager.stopUpdatingLocation()
    }
    
}
















