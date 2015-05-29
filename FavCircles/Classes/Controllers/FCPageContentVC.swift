//
//  FCPageContentVC.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 25/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FCPageContentVC: FCGenericPageContentViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: Constants
    private struct Constants {
        
        // Cell Identifiers
        static let CollectionViewCellFavCellIdentifier: String = "FavCell"
        static let CollectionViewCellFullRowSizeCellIdentifier: String = "FullRowSizeCell"
        
        // Cell Types to manage Regular, Clear and FullRowSize insertions when taps
        static let CollectionViewCellFavTypeRegular: String = "RegularCell"
        static let CollectionViewCellFavTypeClear: String = "ClearCell"
        static let CollectionViewCellFavTypeFullRowSize: String = "FullRowSizeCell"
        
        // SectionHeader Cell IDTypes
        static let CollectionViewSectionHeaderCellIDentifier: String = "SectionHeaderCell"
        
        // Config
        static let ConfigMaxNumberOfUserFavsPerRow: CGFloat = 4 // TODO: Make Configurable by user Prefs
        static let ConfigMaxNumberOfUserFavs: Int = 15 // TODO: Create a variable to make InApp Purchases for more contacts to add

        static let ImageNameForAddItemIcon:String = "add_icon.png"
        static let DefaultProfileImage:String = "default_profile_photo.png"

        static let ConfigCellHightMultiplier: CGFloat = 1.3

    }
    

    // MARK: Outlets
    // Conatiner View
    @IBOutlet weak var containerView: UIView!

    // Background Views in Container
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var blurVisualEffectView: UIVisualEffectView!

    // Collection View in Container
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Model
    var userModel: [UserFav]? {
        didSet {
            setupCellTypeModel()
        }
    }
    var circleName: String?         // Stores the name of the current page Header Title with the circle name
    var cellTypeModel: [String]!    // Stores an array with celltypes for extr views
    
    // MARK: Variables
    // State  to insert NEW FULL SIZE CELL in row below, and clear cells if needed when row not filled
    var isCustomCellViewShown = false
    
    var selectedCell = 0
    var insertedViewCellIndex = 0
    var insertedCellsArray: [Int] = []
    
    var rowIndexPathItemRangeLeft = 0
    var rowIndexPathItemRangeRight = 0
    var numberOfClearCellsToAdd = 0
    var numberOfItemsPerRow = 0
    
    var frameOfCellToAdd = CGSizeMake(0, 0)

    
    // Sets up model of Cell Types
    func setupCellTypeModel() {

        if userModel != nil {
            self.cellTypeModel = []
            if !userModel!.isEmpty {
                for myuser in userModel! {
                    self.cellTypeModel.append(Constants.CollectionViewCellFavTypeRegular)
                }
            }
        }
    }

    
    // MARK: View Controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Populate Model
        setupCellTypeModel()
        
        println("\(self.userModel)")
        println("\(self.userModel!.count)")

        println("\(self.cellTypeModel)")
        println("\(self.cellTypeModel.count)")

        // Setup Gesture Recognizers
        setupGestureRecognizers()
        
        
        // Collection View First Section Top Insets with Cells
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)

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

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        // TODO: Launch direct actions
        self.selectedCell = indexPath.item
        println("Tap has been detected... launching direct actions!!!")

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
        
        // Create Blur Effect and UIVisualEffectView
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurVisualEffectView.frame = self.view.frame
        
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

    
    
    // MARK: Gesture Recognizers

    func setupGestureRecognizers() {

        // Setup Double Tap on UIViewController (does not interfiere with didSelectItemAtIndex)
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "manageSingleTap:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.delaysTouchesBegan = true
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        // Setup Single Tap on UIViewController (does not interfiere with )
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "manageDoubleTap:")
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        doubleTapGestureRecognizer.delaysTouchesBegan = true
        self.view.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    // Single Tap
    func manageSingleTap(sender: UITapGestureRecognizer) {
        //TODO: Finalize
        println("Manage Single Tap")
        
        // When extra full row cell view is shown, it captures taps outside the collection view to dismiss the extra views
        if isCustomCellViewShown {
            
            if (sender.state == UIGestureRecognizerState.Ended) {
                
                // Get the touch point and cell index, if any
                let point = sender.locationInView(self.collectionView)
                if let indexPathForGesture = self.collectionView?.indexPathForItemAtPoint(point) {
                    
                    // Tap on selected cell
                    if (indexPathForGesture.item == self.selectedCell) {
                        
                        //removeExtraCells()
                        println("Hiding Full Row Cell View")
                    }
                } else {
                    // Tap outside the collectionview
                    //removeExtraCells()
                    println("Hiding Full Row Cell View")
                }
                
                
            }
        }
        
    }
    
    
    //Double Taps
    func manageDoubleTap(sender: UITapGestureRecognizer) {
        //TODO: Finalize
        println("Manage Double Tap")
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            
            // Get the touch point and cell index, if any
            let point = sender.locationInView(self.collectionView)
            let indexPathForGesture = self.collectionView?.indexPathForItemAtPoint(point)
            if (indexPathForGesture != nil) {
                println("Double Tap was Recognized")
                
                
                // Identify Index Path to inser the new Full Size Cell in the next row
                self.isCustomCellViewShown = true
                //identifyCellIndexForFullSizeCell(indexPathForGesture!)
                
            } else {
                println("Double Tap was Recognized in view Outside Cells, IS NOT A CELL")
            }
        }
    }
    
    
    /*
    // MARK: Manage Positioning and CRUD of Extra Cells
    
    // Removes Extra Cells
    
    private func removeExtraCells() {
        
        removeExtraCellsForFullRowCellView()
        
        self.isCustomCellViewShown = false
        
        self.numberOfClearCellsToAdd = 0
        self.insertedCellsArray = []
        self.selectedCell = 0
        
        self.collectionView?.reloadData()
        
    }
    
    private func removeExtraCellsForFullRowCellView() {
        if self.insertedCellsArray.count > 0 {
            for item in reverse(self.insertedCellsArray) {
                println("Removing item at index: \(item)")
                println("From Current Array: \(self.modelArray)")
                modelArray.removeAtIndex(item)
                println("Updated Array: \(self.modelArray)")
            }
        }
    }
    
    
    // Add new cells
    
    private func addNewCellAtIndex(index: Int, ofType type: String) {
        
        if index == 0 {
            let colors = ["RED", "ORANGE"]
            let count: UInt32 = UInt32(colors.count)
            let randomIndex = Int(arc4random_uniform(count))
            modelArray.insert("\(colors[randomIndex])", atIndex: 0)
            
        } else {
            modelArray.insert(type, atIndex: index)
        }
        
        self.collectionView?.reloadData()
    }
    
    
    // Manages where to place the extra views
    
    private func identifyCellIndexForFullSizeCell(indexPath: NSIndexPath) {
        self.selectedCell = indexPath.item
        self.insertedViewCellIndex = indexPath.item
        self.rowIndexPathItemRangeLeft = indexPath.item
        self.rowIndexPathItemRangeRight = indexPath.item
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let itemLayoutAttributes = layout.layoutAttributesForItemAtIndexPath(indexPath)
        let itemFrameYPosition = itemLayoutAttributes.frame.origin.y
        
        
        println("\(itemLayoutAttributes)")
        
        if modelArray.count > 0 {
            
            if indexPath.item != (self.modelArray.count-1) {
                // Search by going Right until we find another row with different frame.origin.y
                for index in (indexPath.item+1)...(self.modelArray.count-1) {
                    println("\(index)")
                    
                    let newIndexPath = NSIndexPath(forItem: index, inSection: indexPath.section)
                    let newItemLayoutAttributes = layout.layoutAttributesForItemAtIndexPath(newIndexPath)
                    let newItemFrameYPosition = newItemLayoutAttributes.frame.origin.y
                    
                    if newItemFrameYPosition == itemFrameYPosition {
                        // Item is positioned in the same row than the selected
                        self.rowIndexPathItemRangeRight = index
                    } else { break }
                }
            }
            
            if indexPath.item != 0 {
                // Search by going Left until we find another row with different frame.origin.y
                for index in stride(from: indexPath.item-1, through: 0, by: -1) {
                    println("\(index)")
                    
                    let newIndexPath = NSIndexPath(forItem: index, inSection: indexPath.section)
                    let newItemLayoutAttributes = layout.layoutAttributesForItemAtIndexPath(newIndexPath)
                    let newItemFrameYPosition = newItemLayoutAttributes.frame.origin.y
                    
                    if newItemFrameYPosition == itemFrameYPosition {
                        // Item is positioned in the same row than the selected
                        self.rowIndexPathItemRangeLeft = index
                    } else { break }
                }
            }
            
            //            if indexPath.item == (modelArray.count-1) {
            
            // Number of CLEAR cells to insert before inserting a new cell in a new full row
            let itemFrameWidth = itemLayoutAttributes.frame.width
            let itemFrameHeight = itemLayoutAttributes.frame.height
            
            self.frameOfCellToAdd = CGSizeMake(itemFrameWidth, itemFrameHeight)
            
            let rectForRow = CGRectMake(0, itemFrameYPosition, self.view.bounds.width, itemFrameHeight)
            
            let cellArea = Double(itemFrameWidth * itemFrameHeight)
            let rowArea = Double(self.view.bounds.width * itemFrameHeight)
            
            self.numberOfItemsPerRow = Int(floor(rowArea / cellArea))
            
            //            }
        }
        
        //Zero Based Index
        let numberOfCellsInRow = (self.rowIndexPathItemRangeRight - self.rowIndexPathItemRangeLeft) + 1
        println("Number of Cells in this Row: \(numberOfCellsInRow)")
        
        let numberOfClearCellsToSkipBeforeInsertingNewCellRow = self.rowIndexPathItemRangeRight - indexPath.item
        println("Number of Cells To Skip before creating a Row View: \(numberOfClearCellsToSkipBeforeInsertingNewCellRow)")
        
        if (numberOfCellsInRow == self.numberOfItemsPerRow) {
            self.insertedViewCellIndex = indexPath.item + (numberOfClearCellsToSkipBeforeInsertingNewCellRow + 1)
            addNewCellAtIndex(self.insertedViewCellIndex, ofType: "GREEN")
            self.insertedCellsArray.append(self.insertedViewCellIndex)
            
        } else {
            if (indexPath.item == modelArray.count-1) {
                self.numberOfClearCellsToAdd = self.numberOfItemsPerRow - numberOfCellsInRow
                println("Number of Cells To Add: \(numberOfClearCellsToAdd)")
                
                for i in 1...self.numberOfClearCellsToAdd {
                    addNewCellAtIndex(indexPath.item + i, ofType: "CLEAR")
                    self.insertedCellsArray.append(indexPath.item + i)
                }
                addNewCellAtIndex(self.insertedViewCellIndex + numberOfClearCellsToAdd + 1, ofType: "GREEN")
                self.insertedCellsArray.append(self.insertedViewCellIndex + numberOfClearCellsToAdd + 1)
                
            } else {
                self.numberOfClearCellsToAdd = self.numberOfItemsPerRow - numberOfCellsInRow
                println("Number of Cells To Add: \(numberOfClearCellsToAdd)")
                
                for i in 1...self.numberOfClearCellsToAdd {
                    addNewCellAtIndex(indexPath.item + i + numberOfClearCellsToSkipBeforeInsertingNewCellRow, ofType: "CLEAR")
                    self.insertedCellsArray.append(indexPath.item + i + numberOfClearCellsToSkipBeforeInsertingNewCellRow)
                }
                
                self.insertedViewCellIndex = indexPath.item + (numberOfClearCellsToSkipBeforeInsertingNewCellRow + 1 + numberOfClearCellsToAdd)
                
                addNewCellAtIndex(self.insertedViewCellIndex, ofType: "GREEN")
                self.insertedCellsArray.append(self.insertedViewCellIndex)
                
            }
        }
        
        println("Inserted Cells Array: \(self.insertedCellsArray)")
    }
    */
}
