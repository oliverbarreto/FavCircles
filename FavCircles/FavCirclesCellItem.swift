//
//  FavCirclesCellItem.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 24/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FavCirclesCellItem: NSObject {
    
    // Model: Stores Model Array of a FavCirclesItem with Cell types and the UserFav Object to be displayed with the UICollectionView
    var cellType: String
    var userFav: UserFav? = nil
    
    
    // Initializers
    init(cellType: String, userFav: UserFav?) {
        self.cellType = cellType
        self.userFav = userFav
        
        super.init()
    }
    
    convenience override init() {
        self.init(cellType: "", userFav: UserFav?())
    }
    
    
    // MARK: Printable Protocol
    override var description: String {
        
        var tmpDescription: String = "Description: Cell Type: \(self.cellType)"
        tmpDescription += " and User Fav: \(self.userFav)"
        
        return tmpDescription
    }
   
}
