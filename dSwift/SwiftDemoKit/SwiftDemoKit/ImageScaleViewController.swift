//
//  ImageScaleViewController.swift
//  SwiftDemoKit
//
//  Created by runo on 17/3/17.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit

class ImageScaleViewController: UIViewController {

    let scrollview = UIScrollView.init(frame: kScreenBounds)
    let imageView = UIImageView(image: #imageLiteral(resourceName: "blue"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = scrollview.bounds
        scrollview.addSubview(imageView)
        self.view.addSubview(scrollview)
        scrollview.minimumZoomScale = 1
        scrollview.maximumZoomScale = 10
        scrollview.delegate = self
        
        let tapClick = UITapGestureRecognizer.init(target: self, action: #selector(tapClickGesture(_:)))
        tapClick.numberOfTouchesRequired = 1
        tapClick.numberOfTapsRequired = 2
        scrollview.addGestureRecognizer(tapClick)
    }
    
    func tapClickGesture(_ tap:UITapGestureRecognizer) {
        if scrollview.zoomScale == 1  {
            scrollview .setZoomScale(2.0, animated: true)
        }else{
            scrollview.setZoomScale(1.0, animated: true)
        }
    }
}

extension ImageScaleViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        let horizontalSpace = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2.0 : 0
        let verticalSpace = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.width) / 2.0 :0
        print("h \(verticalSpace)  w\(horizontalSpace)")
        scrollView.contentInset = UIEdgeInsetsMake(verticalSpace, horizontalSpace, verticalSpace, horizontalSpace)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("\(view?.frame) \(scrollview.contentOffset)")
        print("end zoom \(scrollview.zoomScale)")
    }
    
   
}
