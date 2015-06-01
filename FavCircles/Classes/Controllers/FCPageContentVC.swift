//
//  FCPageContentVC.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 25/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FCPageContentVC: FCGenericPageContentViewController, UICollectionViewDataSource, UICollectionViewDelegate, SideBarDelegate {

    // MARK: Constants
    private struct Constants {
        
        // Cell Identifiers
        static let CollectionViewCellFavCellIdentifier: String = "FavCell"
        static let CollectionViewCellFullRowSizeCellIdentifier: String = "FullRowSizeCell"
        static let CollectionViewCellClearCellIdentifier: String = "ClearCell"
        
        // Cell Types to manage Regular, Clear and FullRowSize insertions when taps
        static let CollectionViewCellFavTypeRegular: String = "FavCell"
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
    var userModel: [UserFav]?       // Stores UserFavs array
    var cellTypeModel: [String]!    // Stores an array with celltypes for extr views
    var circleName: String?         // Stores the name of the current page Header Title with the circle name
    
    
    var currentSelectedUser: UserFav? = nil
    
    // Sidebar Object
    var sidebar: SideBar!

    
    
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
    func setupCellTypeModelWithCellType(cellType: String) {
        
        if userModel != nil {
            self.cellTypeModel = []

            if !userModel!.isEmpty {
                for myuser in userModel! {
                    self.cellTypeModel.append(cellType)
                }
            }
        }
    }

    // MARK: View Controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Populate Model
        setupCellTypeModelWithCellType(Constants.CollectionViewCellFavTypeRegular)
        
        // Config Sidebar
        self.sidebar = SideBar(sourceView: self.view, menuItems: ["Family", "Work", "School"])
        self.sidebar.delegate = self
        

        // Setup Gesture Recognizers
        setupGestureRecognizers()
               
        
        // Collection View First Section Top Insets with Cells
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)

        // UIScrollView content offset to push down the section to view's bottom
        self.collectionView.contentInset = UIEdgeInsets(top: 360, left: 0, bottom: 0, right: 0)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("\(size)")
        
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

        switch cellTypeModel[indexPath.item] {
            
          case Constants.CollectionViewCellFavTypeRegular:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CollectionViewCellFavCellIdentifier, forIndexPath: indexPath) as! FCRegularCellCollectionViewCell

            // Configure the cell
            let myuser = userModel![indexPath.item]
            let mycelltype = cellTypeModel![indexPath.item]
            
            cell.cellItem = FCCirclesUserFavCellItems(cellType: mycelltype, userFav: myuser)

            return cell

        case Constants.CollectionViewCellFavTypeClear:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CollectionViewCellClearCellIdentifier, forIndexPath: indexPath) as! FCClearCellCollectionViewCell

            // Configure the cell
            //cell.backgroundColor = UIColor.clearColor()

            return cell

        case Constants.CollectionViewCellFavTypeFullRowSize:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CollectionViewCellFullRowSizeCellIdentifier, forIndexPath: indexPath) as! FCFullRowSizeCellCollectionViewCell
            
            // Configure the cell
            
            if let myuserModel = self.userModel {
                cell.user = myuserModel[selectedCell]
            }
            
            
            //cell.backgroundColor = UIColor.clearColor()

            return cell

        default:

            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CollectionViewCellFavCellIdentifier, forIndexPath: indexPath) as! FCRegularCellCollectionViewCell
            
            // Configure the cell
            let myuser = userModel![indexPath.item]
            let mycelltype = cellTypeModel![indexPath.item]
            
            cell.cellItem = FCCirclesUserFavCellItems(cellType: mycelltype, userFav: myuser)

            return cell
        }
    }
    
    
    
    // MARK: UICollectionView Data Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        if cellTypeModel[indexPath.item] == Constants.CollectionViewCellFavTypeFullRowSize {
            return CGSize(width: self.view.bounds.width, height: self.frameOfCellToAdd.height)
            
        } else if cellTypeModel[indexPath.item] == Constants.CollectionViewCellFavTypeClear {
            return self.frameOfCellToAdd
            
        } else {
            return CGSize(width: self.view.bounds.width/Constants.ConfigMaxNumberOfUserFavsPerRow, height: (self.view.frame.width/Constants.ConfigMaxNumberOfUserFavsPerRow) * Constants.ConfigCellHightMultiplier)
        }
    }

    /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // TODO: Launch direct actions
        self.selectedCell = indexPath.item
        println("Tap has been detected... launching direct actions for cell at \(indexPath.item)!!!")
        
    }
    */
    
    
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
        if self.backgroundImageView.image == nil {
            self.backgroundImageView.image = UIImage(named: "background1.jpg")
        }
        
        // Create Blur Effect and UIVisualEffectView
        if self.blurVisualEffectView == nil {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            self.blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        }
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

        // Setup Single Tap on UIViewController (does not interfiere with )
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "manageDoubleTap:")
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        doubleTapGestureRecognizer.delaysTouchesBegan = true
        //singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(doubleTapGestureRecognizer)

        
        // Setup Double Tap on UIViewController (does not interfiere with didSelectItemAtIndex)
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "manageSingleTap:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.delaysTouchesBegan = true
        //singleTapGestureRecognizer.cancelsTouchesInView = false
        singleTapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        
    }

    
    
    //TODO: Finalize - Single Tap
    func manageSingleTap(sender: UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Ended) {
            
            let point = sender.locationInView(self.collectionView)
            let indexPathForGesture = self.collectionView?.indexPathForItemAtPoint(point)
            

            if !isCustomCellViewShown {
                
                // Get the touch point and cell index, if any
                if (indexPathForGesture != nil) {
                    println("Single Tap was Recognized")
                    self.selectedCell = indexPathForGesture!.item
                    
                    // Identify Index Path to inser the new Full Size Cell in the next row
                    self.isCustomCellViewShown = true
                    identifyCellIndexForFullSizeCell(indexPathForGesture!)
                    
                } else {
                    println("Single Tap was Recognized in view Outside Cells, IS NOT A CELL")
                }

            } else {
            
                // Get the touch point and cell index, if any
                if (indexPathForGesture != nil) {
                    println("Single Tap was Recognized outside the inserted cell... collapse inserted cells")
                    if (indexPathForGesture?.item != self.insertedViewCellIndex) {
                    
                        removeExtraCells()
                        println("Hiding Full Row Cell View")
                    }

                } else {
                    // Tap outside the collectionview
                    println("Single Tap was Recognized outside the collectionview")
                    
                    removeExtraCells()
                    println("Hiding Full Row Cell View")
                }
            }
        }

    }
        

    func manageDoubleTap(sender: UITapGestureRecognizer) {
        println("Manage Double Tap")
    }
        

    
    
    func manageSingleTap222(sender: UITapGestureRecognizer) {
        println("Manage Single Tap")
        
        // When extra full row cell view is shown, it captures taps outside the collection view to dismiss the extra views

        if (sender.state == UIGestureRecognizerState.Ended) {
            
            if isCustomCellViewShown {
                
                // Get the touch point and cell index, if any
                let point = sender.locationInView(self.collectionView)
                if let indexPathForGesture = self.collectionView?.indexPathForItemAtPoint(point) {
                    
                    // Tap on selected cell
                    if (indexPathForGesture.item == self.selectedCell) {
                        
                        removeExtraCells()
                        println("Hiding Full Row Cell View")
                    }
                } else {
                    // Tap outside the collectionview
                    removeExtraCells()
                    println("Hiding Full Row Cell View")
                }
            }
        } else {
            println("Hiding Full Row Cell View")

            // TODO: Select "selected" Cell
//            self.selectedCell = indexPath.item
//            println("Tap has been detected... launching direct actions!!!")
            
            /* Do this in double Taps
            // Identify Index Path to inser the new Full Size Cell in the next row
            self.isCustomCellViewShown = true
            identifyCellIndexForFullSizeCell(indexPath)
            */
        }
        
    }
    
    
    //TODO: Finalize - Double Taps
    func manageDoubleTap222(sender: UITapGestureRecognizer) {
        println("Manage Double Tap")
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            
            if !isCustomCellViewShown {

                // Get the touch point and cell index, if any
                let point = sender.locationInView(self.collectionView)
                let indexPathForGesture = self.collectionView?.indexPathForItemAtPoint(point)
                if (indexPathForGesture != nil) {
                    println("Double Tap was Recognized")
                    
                    
                    // Identify Index Path to inser the new Full Size Cell in the next row
                    self.isCustomCellViewShown = true
                    identifyCellIndexForFullSizeCell(indexPathForGesture!)
                    
                } else {
                    println("Double Tap was Recognized in view Outside Cells, IS NOT A CELL")
                }
            }
        }
    }
    
    

    // MARK: Manage Positioning and CRUD of Extra Cells
    
    // Removes Extra Cells
    
    private func removeExtraCells() {
        
        // Update UICollectionView Methods
        //self.collectionView?.reloadData()
        
        self.collectionView.performBatchUpdates({ () -> Void in
            
            // Prepare Temp array for removing Items in UICollectionView
            var itemPathsArray = [NSIndexPath]()
            
            for itemIndex in self.insertedCellsArray {
                let itemPaths = NSIndexPath(forItem: itemIndex, inSection: 0)
                itemPathsArray.append(itemPaths)
            }
            
            // Delete the items from the data source
            self.removeExtraCellsForFullRowCellView()
            
            // Now delete the items from the collection view
            self.collectionView.deleteItemsAtIndexPaths(itemPathsArray)
            
        }, completion: nil)

    }
    
    
    
    // Rewmove new extra cells
    
    private func removeExtraCellsForFullRowCellView() {
                
        // Sync Model to Reset Extra Cells after updating the model and preparing the remove in UICollectionView
        
        // Removes cells in model
        if self.insertedCellsArray.count > 0 {

            for item in reverse(self.insertedCellsArray) {

                userModel!.removeAtIndex(item)
                cellTypeModel!.removeAtIndex(item)
            }
        }

        // Reset state vars
        self.isCustomCellViewShown = false
        self.numberOfClearCellsToAdd = 0
        self.insertedCellsArray = []
        self.selectedCell = 0
        
        
        // Sync CellTypes Array Model
        setupCellTypeModelWithCellType(Constants.CollectionViewCellFavTypeRegular) //clears extra cell of type other than regular
        
    }
    
    
    // TODO: Add new cells
    
    private func addCells() {
    
        self.collectionView.performBatchUpdates({ () -> Void in
            
            // Prepare Temp array for removing Items in UICollectionView
            var itemPathsArray = [NSIndexPath]()
            
            for itemIndex in self.insertedCellsArray {
                let itemPaths = NSIndexPath(forItem: itemIndex, inSection: 0)
                itemPathsArray.append(itemPaths)
            }
            
            
            // Syncs the model First: Inserts the items from the data source
            // Now delete the items from the collection view
            self.collectionView.insertItemsAtIndexPaths(itemPathsArray)
            
            }, completion: nil)
    }
    
    
    private func addNewCellAtIndex(index: Int, withUser user: UserFav, andCellType cellType:String) {

        

            switch (cellType) {
                
                // TODO: Use this to add new users to the model...
            case Constants.CollectionViewCellFavTypeRegular:
                
                if user.isEmpty() {
                    
                    //Create a Random Dummy User for testing
                    let count: UInt32 = UInt32(self.userModel!.count)
                    let randomIndex = Int(arc4random_uniform(count))
                    
                    self.userModel!.insert(self.userModel![randomIndex], atIndex: index)
                    self.cellTypeModel[index] = cellType
                    //cellTypeModel!.insert(cellType, atIndex: index)
                    
                } else {
                    self.userModel!.insert(user, atIndex: index)
                    self.cellTypeModel[index] = cellType
                    //cellTypeModel!.insert(cellType, atIndex: index)
                }
                
                break;
                
            case Constants.CollectionViewCellFavTypeClear, Constants.CollectionViewCellFavTypeFullRowSize:
                
                self.userModel!.insert(user, atIndex: index)
                self.cellTypeModel.insert(cellType, atIndex: index)
                
                break;
            default:
                break;
            }
            
        
        // Update UICollectionView Methods
        //self.collectionView?.reloadData()
        
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
        
        
        if userModel!.count > 0 {
            
            if indexPath.item != (self.userModel!.count-1) {
                
                // Search by going Right until we find another row with different frame.origin.y
                for index in (indexPath.item+1)...(self.userModel!.count-1) {
                    
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
        let numberOfClearCellsToSkipBeforeInsertingNewCellRow = self.rowIndexPathItemRangeRight - indexPath.item

        // Selected cell in a row full of cells
        if (numberOfCellsInRow == self.numberOfItemsPerRow) {
            
            self.collectionView.performBatchUpdates({ () -> Void in

                // Update the Model
                self.insertedViewCellIndex = indexPath.item + (numberOfClearCellsToSkipBeforeInsertingNewCellRow + 1)
                
                // Add Cell
                self.insertedCellsArray.append(self.insertedViewCellIndex)
                self.addNewCellAtIndex(self.insertedViewCellIndex, withUser: UserFav(), andCellType: Constants.CollectionViewCellFavTypeFullRowSize)


                // Prepare Temp array for removing Items in UICollectionView
                var itemPathsArray = [NSIndexPath]()
                
                for itemIndex in self.insertedCellsArray {
                    let itemPaths = NSIndexPath(forItem: itemIndex, inSection: 0)
                    itemPathsArray.append(itemPaths)
                }
                

                // Insert Cells in UICollectionView
                self.collectionView.insertItemsAtIndexPaths(itemPathsArray)

                
                
            }, completion: nil)
            

        // Selected cell is in the middle of a row, or in a row not full of cells
        } else {
            
            // Selected cell is the last in the model
            if (indexPath.item == userModel!.count-1) {
                
                self.collectionView.performBatchUpdates({ () -> Void in
                    
                    // Update the Model
                    self.numberOfClearCellsToAdd = self.numberOfItemsPerRow - numberOfCellsInRow
                    
                    // Adds clear cells before the full row
                    for i in 1...self.numberOfClearCellsToAdd {
                        // Add Cell
                        self.insertedCellsArray.append(indexPath.item + i)
                        self.addNewCellAtIndex(indexPath.item + i, withUser: UserFav(), andCellType: Constants.CollectionViewCellFavTypeClear)
                    }
                    
                    // Add Cell
                    self.insertedViewCellIndex = self.insertedViewCellIndex + self.numberOfClearCellsToAdd + 1
                    
                    self.insertedCellsArray.append(self.insertedViewCellIndex)
                    self.addNewCellAtIndex(self.insertedViewCellIndex, withUser: UserFav(), andCellType: Constants.CollectionViewCellFavTypeFullRowSize)

                    
                    // Prepare Temp array for removing Items in UICollectionView
                    var itemPathsArray = [NSIndexPath]()
                    
                    for itemIndex in self.insertedCellsArray {
                        let itemPaths = NSIndexPath(forItem: itemIndex, inSection: 0)
                        itemPathsArray.append(itemPaths)
                    }
                    
                    // Insert Cells in UICollectionView
                    self.collectionView.insertItemsAtIndexPaths(itemPathsArray)
                    
                }, completion: nil)
                
                
                
            // Selected cell is not the last one
            } else {
                self.numberOfClearCellsToAdd = self.numberOfItemsPerRow - numberOfCellsInRow
                
                self.collectionView.performBatchUpdates({ () -> Void in

                    // Update the Model
                    for i in 1...self.numberOfClearCellsToAdd {
                        // Add Cell
                        self.insertedCellsArray.append(indexPath.item + i + numberOfClearCellsToSkipBeforeInsertingNewCellRow)
                        self.addNewCellAtIndex(indexPath.item + i + numberOfClearCellsToSkipBeforeInsertingNewCellRow, withUser: UserFav(), andCellType: Constants.CollectionViewCellFavTypeClear)
                    }
                    
                    self.insertedViewCellIndex = indexPath.item + (numberOfClearCellsToSkipBeforeInsertingNewCellRow + 1 + self.numberOfClearCellsToAdd)
                    
                    // Add Cell
                    self.insertedCellsArray.append(self.insertedViewCellIndex)
                    self.addNewCellAtIndex(self.insertedViewCellIndex, withUser: UserFav(), andCellType: Constants.CollectionViewCellFavTypeFullRowSize)
                    
                    
                    // Prepare Temp array for removing Items in UICollectionView
                    var itemPathsArray = [NSIndexPath]()
                    
                    for itemIndex in self.insertedCellsArray {
                        let itemPaths = NSIndexPath(forItem: itemIndex, inSection: 0)
                        itemPathsArray.append(itemPaths)
                    }
                    
                    // Insert Cells in UICollectionView
                    self.collectionView.insertItemsAtIndexPaths(itemPathsArray)
                    
                }, completion: nil)
            }
        }
    }
    
    
    
    //MARK: SidebarDelegate Protocol
    func sidebarDidSelectRowAtIndex(index: Int) {
        println("\(index)")
    }
    
    
    
    
    

}
