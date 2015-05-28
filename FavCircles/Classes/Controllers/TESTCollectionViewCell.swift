//
//  TESTCollectionViewCell.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 28/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class TESTCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    // MARK: Model
    var cellItem: FavCirclesCellItem? {
        didSet {
            updateUI()
            
        }
    }
    
    func updateUI() {
        
        // Reset any existing info
        self.image.image = nil
        self.label.text = nil
        
        if let cellitem = self.cellItem {
            println("Current CellItem: \(cellitem)")
            
            if let user = cellitem.userFav {
                println("Current User: \(user)")
                
                let myName = user.name!
                let myImage = UIImage(named: user.imageName!)!
                
                println("Current Cell UserName: \(myName)")
                println("Current Cell: \(user.imageName)")
                
                
                self.label.text = myName
                self.image.image = myImage
            }
        }
    }
    
}
