//
//  ImagePickerViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/6/2.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var showImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    @IBAction func selectBtnClick(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            print("support camera")
        }else {
            print("not support")
        }
        print(UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera))
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.cameraDevice = .rear
        
        imagePicker.delegate = self
        let type = [kUTTypeMovie as String]
        imagePicker.mediaTypes = type
        imagePicker.videoQuality = .type640x480
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.video
        imagePicker.videoMaximumDuration = 10
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("取消选择")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        showImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }

}
