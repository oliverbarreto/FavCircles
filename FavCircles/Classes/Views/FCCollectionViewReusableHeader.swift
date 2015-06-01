//
//  FCCollectionViewReusableHeader.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 26/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FCCollectionViewReusableHeader: UICollectionReusableView {
    
    // MARK: Outlets
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    @IBOutlet weak var sectionHeaderDateLabel: UILabel! {
        willSet {
                    let currentDate: NSDate = NSDate()
                    
                    let formatter = NSDateFormatter()
                    formatter.stringFromDate(currentDate)
                    formatter.dateStyle = NSDateFormatterStyle.FullStyle
                    formatter.timeStyle = NSDateFormatterStyle.NoStyle
                    
                    newValue.text = formatter.stringFromDate(currentDate)
        }
    }
}
