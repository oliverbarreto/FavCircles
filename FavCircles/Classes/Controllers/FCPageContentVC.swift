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
    @IBOutlet weak var collectionView: UICollectionView!

    // To create Bluf Effect
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var blurVisualEffectView: UIVisualEffectView!

    
    // MARK: Model
    var userModel: [UserFav]?
    var circleName: String?
    
    // MARK: Variables
    private struct Constants {
        
        // Cell Identifiers
        static let CollectionViewCellFavCellIdentifier: String = "FavCell"
        static let CollectionViewCellFullRowSizeCellIdentifier: String = "FullRowSizeCell"
        
        // Cell Types
        static let CollectionViewCellFavTypeRegular: String = "RegularCell"
        static let CollectionViewCellFavTypeClear: String = "ClearCell"
        static let CollectionViewCellFavTypeFullRowSize: String = "FullRowSizeCell"
    
        // SectionHeader Cell IDTypes
        static let CollectionViewSectionHeaderCellIDentifier: String = "SectionHeaderCell"
    
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
        
        //Populate Model
        
        
        // Collection View First Section Top Insets with Cells
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 25, left: 0, bottom: 40, right: 0)

        // UIScrollView content offset to push down the section to view's bottom
        self.collectionView.contentInset = UIEdgeInsets(top: 360, left: 0, bottom: 0, right: 0)
        
        
    }
    
    override func viewWillLayoutSubviews() {

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Background
        //setupBackgroundImageViewWithAutolayoutConstrains()
        setupBackgroundImageViewWithFrame()
        
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

        if self.userModel != nil {
            return self.userModel!.count
        } else { return 0 }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // Configure the cell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CollectionViewCellFavCellIdentifier, forIndexPath: indexPath) as! FCRegularCellCollectionViewCell
        
        // Configure the cell
        
        if let model = self.userModel {
            let myuser = model[indexPath.item]
            cell.cellItem = FavCirclesCellItem(cellType: "regular", userFav: myuser)
        }

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

            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.CollectionViewSectionHeaderCellIDentifier, forIndexPath: indexPath) as! FCCollectionViewReusableHeader

            if let sectionName = self.circleName {
                headerView.sectionHeaderLabel?.text = "\(sectionName)"

            } else {
                headerView.sectionHeaderLabel?.text = "Group"
                }
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    
    //MARK: Custom Methods
    
    func setupBackgroundImageViewWithFrame() {
        // Set Background Image
        self.backgroundImageView.image = UIImage(named: "background1.jpg")
        
        // Set blurVisualEffectView's frame
//        if self.blurVisualEffectView == nil {
//            self.blurVisualEffectView = UIVisualEffectView(frame: self.view.bounds)
//        }
        
        // Create Blur Effect and UIVisualEffectView
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurVisualEffectView.frame = self.backgroundView.bounds
        
        // Add subview on top of background
        self.backgroundView.insertSubview(self.blurVisualEffectView, atIndex: 1)
    
    }
    
    
    func setupBackgroundImageViewWithAutolayoutConstrains() {

        // Set Background Image
        self.backgroundImageView.image = UIImage(named: "background1.jpg")
        
        
        // Create Blur Effect and UIVisualEffectView
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurVisualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //self.blurVisualEffectView.frame = self.containerViewForBlurEffects.bounds
        //self.blurVisualEffectView.hidden = true
        
        
        // Add subview on top of background
        self.backgroundView.insertSubview(self.blurVisualEffectView, atIndex: 1)
        
        addConstrains()
    }

    func addConstrains() {
        
        var constrains = [NSLayoutConstraint]()
        
        // Blur Effects view
        constrains.append(NSLayoutConstraint(item: self.blurVisualEffectView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        constrains.append(NSLayoutConstraint(item: self.blurVisualEffectView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        constrains.append(NSLayoutConstraint(item: self.blurVisualEffectView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        constrains.append(NSLayoutConstraint(item: self.blurVisualEffectView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        
        self.backgroundView.addConstraints(constrains)
    }

}
