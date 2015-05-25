//
//  RoundedImageView.swift
//  testing
//
//  Created by David Oliver Barreto Rodríguez on 22/5/15.
//  Copyright (c) 2015 Oliver Barreto. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIView {

    // MARK: View Variables & IBDesignable VArs
    var backgroundLayer: CAShapeLayer!
    var imageLayer: CALayer!
    
    @IBInspectable var image: UIImage?
    @IBInspectable var imageBackgroundColor:UIColor = UIColor.grayColor()
    @IBInspectable var imageBorderInsets: CGFloat = 1.0
    
    
    
    // MARK: View LifeCycle MEthods
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackgroundLayer()
        setupBackgroundImageLayer()
        setupImage()
    }
    
    
    
    // MARK: Custom Initializers Methods
    
    func setupBackgroundLayer() {
        
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            
            let rect = CGRectInset(bounds, imageBorderInsets / 2.0, imageBorderInsets / 2.0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.lineWidth = imageBorderInsets
            backgroundLayer.fillColor = imageBackgroundColor.CGColor
        }
        
        backgroundLayer.frame = layer.bounds
    }
    
    
    func setupBackgroundImageLayer() {
        
        if imageLayer == nil {
            let mask = CAShapeLayer()
            let dx = imageBorderInsets + 3.0
            let path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, dx, dx))
            mask.fillColor = UIColor.blackColor().CGColor
            mask.path = path.CGPath
            mask.frame = self.bounds
            layer.addSublayer(mask)
            
            imageLayer = CAShapeLayer()
            imageLayer.frame = self.bounds
            imageLayer.mask = mask
            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            layer.addSublayer(imageLayer)
        }
        
    }
    
    func setupImage() {
        if imageLayer != nil {
            if let pic = image {
                imageLayer.contents = pic.CGImage
            } else {
                imageLayer.contents = UIImage(named: "default_profile_photo.png")?.CGImage
            }
        }
    }

    
}
