//
//  FCPageContentVC.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 25/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FCPageContentVC: FCGenericPageContentViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    // MARK: Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Model
    private var userFavContactsArray = [UserFav]()

    
    // MARK: Variables
    private struct Constants {
        // Cell Identifiers
        static let CollectionViewCellFavCellIdentifier: String = "FavCell"
        static let CollectionViewCellFullRowSizeCellIdentifier: String = "FullRowSizeCell"
        
        // Cell Types
        static let CollectionViewCellFavTypeRegular: String = "RegularCell"
        static let CollectionViewCellFavTypeClear: String = "ClearCell"
        static let CollectionViewCellFavTypeFullRowSize: String = "FullRowSizeCell"
    
        // SectionHeader Cell Types
        static let CollectionViewSectionHeaderCell: String = "SectionHeaderCell"
    
        // Config
        static let ConfigCellHightMultiplier: CGFloat = 1.3
        static let ConfigMaxNumberOfUserFavsPerRow: CGFloat = 4 // TODO: Make Configurable by user Prefs
        static let ConfigMaxNumberOfUserFavs: Int = 15 // TODO: Create a variable to make InApp Purchases for more contacts to add
        static let ImageNameForAddItemIcon:String = "add_icon.png"
        static let DefaultProfileImage:String = "default_profile_photo.png"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userFavContactsArray = LibraryAPI.sharedInstanceAPI.getAllUserFavs()
        
        println("\(userFavContactsArray)")
        
        
        // First Section Top Insets
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 25, left: 0, bottom: 40, right: 0)
        self.collectionView.contentInset = UIEdgeInsets(top: 360, left: 0, bottom: 0, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: View Controller Customization
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    
    // MARK: - Navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return userFavContactsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // Configure the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CollectionViewCellFavCellIdentifier, forIndexPath: indexPath) as! FCRegularCellCollectionViewCell
        

        println("Current User: \(userFavContactsArray[indexPath.item])")

        // TODO: Create FavCircle Cell in IB
        if let name = userFavContactsArray[indexPath.item].name {
            cell.cellNameLabel.text = name
        }
        if let image = UIImage(named: userFavContactsArray[indexPath.item].imageName) {
            cell.cellImageView.image = image
        }
        
        println("\(cell.frame)")
        println("\(cell.cellImageView.frame)")
        
        return cell
        
    }
    
    
    
    // MARK: UICollectionView Data Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.width/Constants.ConfigMaxNumberOfUserFavsPerRow, height: (self.view.frame.width/Constants.ConfigMaxNumberOfUserFavsPerRow) * Constants.ConfigCellHightMultiplier)
        
        /*
        else if modelArray[indexPath.item] == "CLEAR" {
        return self.frameOfCellToAdd
        } else {
        return CGSize(width: self.view.bounds.width/4, height: self.view.bounds.width/4);
        }
        */
        
        
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {

        case UICollectionElementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.CollectionViewSectionHeaderCell, forIndexPath: indexPath) as! FCCollectionViewReusableHeader

            headerView.sectionHeaderLabel?.text = "Family"
            return headerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    /*
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reusableview: UICollectionReusableView? = nil
        
        /*
        if (kind == UICollectionElementKindSectionHeader) {
        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
        headerView.title.text = title;
        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
        }
        
        if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
        }
        
        return reusableview;ectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        */
        
    }
*/
}
