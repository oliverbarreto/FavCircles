//
//  FCMainPageViewController.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 28/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

class FCMainPageViewController: UIViewController, UIPageViewControllerDataSource {

    
    // MARK: Constants
    private struct PageViewControllerIdentifier {
        static let PageContentViewController: String = "FCPageContentVC"
        static let PageContainerViewController: String = "FCPageContainerViewController"
        static let PageControllerMainEntryPointViewController: String = "FCMainPageViewController"
    }
    
    
    // MARK: Model
    private var circlesArray = ["Family", "Work", "School"]
    private var currentFavCircle = 0
   
    private var circlesModel = [String: [UserFav]]()

    // Page Navigation Controller
    var pageViewController: UIPageViewController!
    private var currentPageContentViewController = 0

    
    
    // MARK: View Controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create here everything except what needs frames and layout
        
        //Populate Model
        if !self.circlesArray.isEmpty {
            for circle in circlesArray {
                println("\(circle)")

                let users:[UserFav] = LibraryAPI.sharedInstanceAPI.getAllUserFavs()
                circlesModel[circle] = users
            }
        }
        println("\(circlesModel)")

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Instantiate the initial PageViewController
        resetPageViewController()
        
        // Memento: Add observer for Entering Background
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"saveCurrentState", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: Memento Pattern
    func saveCurrentState() {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        //NSUserDefaults.standardUserDefaults().setInteger(currentAlbumIndex, forKey: "currentFastFavsIndex")
        
        LibraryAPI.sharedInstanceAPI.saveUserFavs()
    }
    
    func loadPreviousState() {
        //currentFastFavsGroupIndex = NSUserDefaults.standardUserDefaults().integerForKey("currentFastFavsGroupIndex")
        //showDataForFastFavsGroupIndex(currentFastFavsGroupIndex)
    }
    
    
    
    
    // MARK: Utility Methods
    
    func resetPageViewController() {
        
        // Create PageViewController and datasource
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(PageViewControllerIdentifier.PageContainerViewController) as! UIPageViewController
        self.pageViewController.dataSource = self
        
        
        // Setup PageViewController first VC
        var startingVC: FCPageContentVC = self.viewControllerAtIndex(0) as! FCPageContentVC
        let startingArrayOfVCs = [startingVC]
        self.pageViewController.setViewControllers(startingArrayOfVCs, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = self.view.frame
        
        
        // Add the PageViewController
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        if (circlesArray.count == 0 || index >= circlesArray.count) {
            return FCPageContentVC()
        }
        
        // Create a New FCPageContent View Controllers
        var vc: FCPageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier(PageViewControllerIdentifier.PageContentViewController) as! FCPageContentVC
        
        // Set Model
        if !circlesArray.isEmpty {
            
            let circlename = circlesArray[index]
            vc.index = index
            vc.circleName = circlesArray[index]
            vc.userModel = circlesModel[circlename]
        }
        
        return vc
    }
    
    
    /* move to a specific content view controller page
    
    - (void)scrollToNext     {
    UIViewController *current = self.viewControllers[0];
    NSInteger currentIndex = [self.model indexForViewController:current];
    UIViewController *nextController = [self.model viewControllerForIndex:++currentIndex];
    if (nextController) {
    NSArray *viewControllers = @[nextController];
    // This changes the View Controller and calls the presentationIndexForPageViewController datasource method
    [self setViewControllers:viewControllers
    direction:UIPageViewControllerNavigationDirectionForward
    animated:YES
    completion:nil];
    }
    */
    

    
    // MARK: PageViewController DataSource Protocol
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        
        var vc = viewController as! FCPageContentVC
        var index = 0
        
        if vc.index != nil {
            index = vc.index!
            if (index == 0 || circlesArray.count == 0 ) {
                return nil
            }
        }
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! FCPageContentVC
        var index = 0
        
        if vc.index != nil {

            index = vc.index!
            index++
            
            if (index >= circlesArray.count) {
                return nil
            }
        }
        
        return self.viewControllerAtIndex(index)
    }
    
}
