//
//  FavCirclesRegularCellCollectionViewCell.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 25/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FCRegularCellCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet weak var cellImageView: RoundedImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
    
    // MARK: Model
    var cellItem: FCCirclesUserFavCellItems? {
        didSet {
            updateUI()
        
        }
    }
    
    func updateUI() {
        
        // Reset any existing info
        self.cellImageView.profileImage = nil
        self.cellNameLabel.text = nil
        
        if let cellitem = self.cellItem {
            if let user = cellitem.userFav {
                
                let myName = user.name!
                let myImage = UIImage(named: user.imageName!)!
                
                self.cellNameLabel.text = myName
                self.cellImageView.profileImage = myImage
            }
        }
    }
}
