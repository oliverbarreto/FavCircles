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
    }
    
    @IBAction func makeText(sender: UIButton) {
    }
    
    @IBAction func makeWhatsapp(sender: UIButton) {
    }
   
    
}
