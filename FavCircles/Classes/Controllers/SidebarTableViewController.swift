//
//  SidebarTableViewController.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 30/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit


protocol SidebarTableViewControllerDelegate {

    func sidebarDidSelectRowAtIndexPath(index: NSIndexPath)
}



class SidebarTableViewController: UITableViewController {
    
    // MARK: Constants
    
    private struct Constants {
        static let SidebarTableViewCellIdentifier: String  = "sidebarCellItem"
    }
    
    
    // MARK: Protocol
    var delegate: SidebarTableViewControllerDelegate?

    
    // MARK: Model
    //var tableData = [SidebarTableViewControllerCellItem]()
    var tableData = [String]()
    
    
    
    // MARK: TableView DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(Constants.SidebarTableViewCellIdentifier) as? UITableViewCell

        // Configure the Cell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Constants.SidebarTableViewCellIdentifier)
            
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            
            // Configure Selected State of the Cell
            let selectedView: UIView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        cell!.textLabel?.text = tableData[indexPath.item]

        return cell!
    }
    

    // MARK: TableView Delegate
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.sidebarDidSelectRowAtIndexPath(indexPath)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0 // Small Cell Heights!
    }
    

}
