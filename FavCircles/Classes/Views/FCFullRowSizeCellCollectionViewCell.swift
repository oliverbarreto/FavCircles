//
//  FCFullRowSizeCellCollectionViewCell.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 29/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FCFullRowSizeCellCollectionViewCell: UICollectionViewCell {
    
    // MARK: Model 
    var user: UserFav?
    
    @IBAction func makeCall(sender: UIButton) {
        if let myuser = user {
            let phoneURL: NSURL = NSURL(string: "tel:\(myuser.favItem)")!
            
            if UIApplication.sharedApplication().canOpenURL(phoneURL) {
                UIApplication.sharedApplication().openURL(phoneURL)
            }
        }
    }
    
    @IBAction func makeFaceTime(sender: UIButton) {
        if let myuser = user {
            let facetimeURL: NSURL = NSURL(string: "facetime://\(myuser.favItem)")!
            
            if UIApplication.sharedApplication().canOpenURL(facetimeURL) {
                UIApplication.sharedApplication().openURL(facetimeURL)
            }
        }
    }
    
    @IBAction func makeText(sender: UIButton) {
        if let myuser = user {
            let smsURL: NSURL = NSURL(string: "sms:\(myuser.favItem)")!
            
            if UIApplication.sharedApplication().canOpenURL(smsURL) {
                UIApplication.sharedApplication().openURL(smsURL)
            }
        }

    }
    
    @IBAction func makeWhatsapp(sender: UIButton) {
        if let myuser = user {
            let whatsappURL: NSURL = NSURL(string: "whatsapp://app")!
            
            if UIApplication.sharedApplication().canOpenURL(whatsappURL) {
                UIApplication.sharedApplication().openURL(whatsappURL)
            }
        }
    }
   
    
}
