//
//  AlertViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/6/2.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func alertClick(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "alert", message: "message", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { _ in
            print("cancel btn click")
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            print("ok btn click")
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func alertSheetClick(_ sender: AnyObject) {
        
        let alerController = UIAlertController(title: "title", message: "message", preferredStyle: .actionSheet)
        let cancelAct = UIAlertAction(title: "cancel", style: .cancel) { (_) in
            print("cancel btn click")
        }
        alerController.addAction(cancelAct)
        
        let okAction = UIAlertAction(title: "title", style: .destructive) { (_) in
            print("ok btn click")
        }
        alerController.addAction(okAction)
        self.present(alerController, animated: true, completion: nil)
    }
    @IBAction func inputAlert(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (_) in
            print("cancel btn click")
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            print("ok btn click")
            let userName = alertController.textFields![0].text
            let password = alertController.textFields![0].text
            
            print("\(userName) \n \(password)");
        }
        alertController.addAction(okAction)
        
        alertController.addTextField { (tf) in
            tf.placeholder = "name"
            tf.isSecureTextEntry = false
        }
        alertController.addTextField { (tf) in
            tf.placeholder = "password"
            tf.isSecureTextEntry = true
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
