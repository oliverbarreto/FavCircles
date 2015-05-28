//
//  TESTCollectionViewController.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 28/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class TESTCollectionViewController: UICollectionViewController {

    
    var model: [UserFav]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.model = [
            UserFav(name: "Oliver", lastName: "Barreto", type: "iPhone", favItem: "+34610700505", imageName: "Oliver.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "iPhone", favItem: "+34670875979", imageName: "ARAL.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "Work", favItem: "+34922602083", imageName: "ARAL.jpg", favGroup: "Family"),
            UserFav(name: "Mima", lastName: "Rodríguez Pestano", type: "iPhone", favItem: "+34697414021", imageName: "Mima.jpeg", favGroup: "Family"),
            
            UserFav(name: "Default", lastName: "Default", type: "Default", favItem: "", imageName: "default.png", favGroup: "Family"),
            UserFav(name: "Colegio Pureza de María", lastName: "", type: "Work", favItem: "+34922277763", imageName: "purezamaria.jpeg", favGroup: "Colegio"),
            UserFav(name: "Oliver", lastName: "Barreto", type: "iPhone", favItem: "+34610700505", imageName: "Oliver.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "iPhone", favItem: "+34670875979", imageName: "ARAL.jpg", favGroup: "Family"),

            UserFav(name: "Default", lastName: "Default", type: "Default", favItem: "", imageName: "default.png", favGroup: "Family"),
            UserFav(name: "Colegio Pureza de María", lastName: "", type: "Work", favItem: "+34922277763", imageName: "purezamaria.jpeg", favGroup: "Colegio"),
            UserFav(name: "Oliver", lastName: "Barreto", type: "iPhone", favItem: "+34610700505", imageName: "Oliver.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "iPhone", favItem: "+34670875979", imageName: "ARAL.jpg", favGroup: "Family"),
            
            UserFav(name: "Default", lastName: "Default", type: "Default", favItem: "", imageName: "default.png", favGroup: "Family"),
            UserFav(name: "Colegio Pureza de María", lastName: "", type: "Work", favItem: "+34922277763", imageName: "purezamaria.jpeg", favGroup: "Colegio"),
            UserFav(name: "Oliver", lastName: "Barreto", type: "iPhone", favItem: "+34610700505", imageName: "Oliver.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "iPhone", favItem: "+34670875979", imageName: "ARAL.jpg", favGroup: "Family"),
            
            UserFav(name: "Default", lastName: "Default", type: "Default", favItem: "", imageName: "default.png", favGroup: "Family"),
            UserFav(name: "Colegio Pureza de María", lastName: "", type: "Work", favItem: "+34922277763", imageName: "purezamaria.jpeg", favGroup: "Colegio"),
            UserFav(name: "Oliver", lastName: "Barreto", type: "iPhone", favItem: "+34610700505", imageName: "Oliver.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "iPhone", favItem: "+34670875979", imageName: "ARAL.jpg", favGroup: "Family"),

            
            UserFav(name: "Default", lastName: "Default", type: "Default", favItem: "", imageName: "default.png", favGroup: "Family"),
            UserFav(name: "Colegio Pureza de María", lastName: "", type: "Work", favItem: "+34922277763", imageName: "purezamaria.jpeg", favGroup: "Colegio"),
            UserFav(name: "Oliver", lastName: "Barreto", type: "iPhone", favItem: "+34610700505", imageName: "Oliver.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "Work", favItem: "+34922602083", imageName: "ARAL.jpg", favGroup: "Family")
        ]

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.model.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TESTCollectionViewCell
    
        // Configure the cell
        
        let user = model[indexPath.item]
        
        cell.cellItem = FavCirclesCellItem(cellType: "", userFav: user)
        
        //cell.image.image = UIImage(named: user.imageName!)!
        //cell.label.text = user.name!
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
