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
    var cellItem: FavCirclesCellItem? {
        didSet {
            updateUI()
        
        }
    }
    
    func updateUI() {
        
        // Reset any existing info
        self.cellImageView.profileImage = nil
        self.cellNameLabel.text = nil
        
        if let cellitem = self.cellItem {
            println("Current CellItem: \(cellitem)")

            if let user = cellitem.userFav {
                println("Current User: \(user)")
                
                let myName = user.name!
                let myImage = UIImage(named: user.imageName!)!
                
                println("Current Cell UserName: \(myName)")
                println("Current Cell: \(user.imageName)")

                
                self.cellNameLabel.text = myName
                self.cellImageView.profileImage = myImage
            }
        }
    }
}
