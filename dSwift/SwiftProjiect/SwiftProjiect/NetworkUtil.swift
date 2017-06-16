//
//  NetworkUtil.swift
//  SwiftProjiect
//
//  Created by runo on 17/6/13.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NetworkUtil: NSObject {

    static let sharUtil = NetworkUtil()
    
    func loadHomeItemInfo(finished:@escaping (_ homeItems:[HomeItemModel]) -> ()) {
        
        let url = "http://api.dantangapp.com/v2/channels/preset?gender=1&generation=1"
        Alamofire.request(url).responseJSON { (dataResponse) in
            
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
            SVProgressHUD.show()
            if let res = dataResponse.result.value {
                let dic = JSON(res)
                var marr = [HomeItemModel]()
                let data = dic["data"].dictionary
                
                if dic["code"].intValue != 200 {
                    
                    SVProgressHUD.showInfo(withStatus: dic["message"].stringValue)
                    return
                }
                SVProgressHUD.dismiss()
                if let channels = data?["channels"]?.arrayObject {
                    for channel in channels {
                        let tmp = HomeItemModel.init(dict: channel as! [String: AnyObject])
                        marr.append(tmp)
                    }
                }
                
                finished(marr)
            }
        }
    }
    
    func loadTopicItem(id type:Int,DataCB datacb: @escaping(_ items:[TopicItemModel]) -> ()) {
        
        let url = "http://api.dantangapp.com/" + "v1/channels/\(type)/items"
        let params = ["gender": 1,
                      "generation": 1,
                      "limit": 20,
                      "offset": 0]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                datacb([TopicItemModel]())
                return
            }
            
            if let value = response.result.value {
                let dict = JSON(value)
                print(dict)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == 200 else {
                    SVProgressHUD.showInfo(withStatus: message)
                    datacb([TopicItemModel]())
                    return
                }
                let data = dict["data"].dictionary
                var homeArrr = [TopicItemModel]()
                if let items = data?["items"]?.arrayObject {
                    for intem in items {
                        let homeItem = TopicItemModel.init(dict: intem as! [String: AnyObject])
                        homeArrr.append(homeItem)
                    }
                }
                datacb(homeArrr)
            }
        }
    }
    
}
