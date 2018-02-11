//
//  LoadingOverlay.swift
//  Blob
//
//  Created by gieoon on 2018/02/11.
//  Copyright © 2018 shunkagaya. All rights reserved.
//

import UIKit

public class LoadingOverlay{
    
    var overlayView = UIView()
    var strLabel = UILabel()
    var logoImg = UIImageView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        strLabel = UILabel(frame: CGRect(x: screenSize!.width / 20, y: screenSize!.height - 20, width: screenSize!.width, height: 20))
        strLabel.adjustsFontSizeToFitWidth = true
        strLabel.text = "v0.1.0 March 2018 designed & developed by Juunoco.ltd in Auckland"
        strLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor.black//UIColor(white: 0.1, alpha: 0.7)
        
        //TODO add image data here
        //let img = UIImage(named: )
        //logoImg = UIImageView(image: img!)
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        view.addSubview(imageView)
        
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(rgb: 0xD0C69B)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 12
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(strLabel)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        strLabel.removeFromSuperview()
    }
}
