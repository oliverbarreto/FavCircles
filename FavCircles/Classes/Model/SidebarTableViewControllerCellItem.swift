//
//  SidebarTableViewControllerCellItem.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 30/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class SidebarTableViewControllerCellItem: NSObject {
    
    // MARK: Model
    var title: String = ""
    var iconName: String = "default_circle_icon.png"
    
    
    // Initializers
    convenience override init() {
        self.init(title: "", iconName: "")
    }

    init(title: String, iconName: String) {
        self.title = title
        self.iconName = iconName

        super.init()
    }

}
