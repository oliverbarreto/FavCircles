//
//  Sidebar.swift
//  FavCircles
//
//  Created by David Oliver Barreto Rodríguez on 30/5/15.
//  Copyright (c) 2015 David Oliver Barreto Rodríguez. All rights reserved.
//

import UIKit

// MARK: SideBarDelegate @objc Protocol

@objc protocol SideBarDelegate {
    func sidebarDidSelectRowAtIndex(index:Int)
    optional func sideBarWillClose()
    optional func sideBarWillOpen()
}


class SideBar: NSObject, SidebarTableViewControllerDelegate, UIGestureRecognizerDelegate {

    // MARK: Constants
    private struct Constants {
        static let SidebarConfigSidebarWidth: CGFloat = 150.0
        static let SidebarConfigTableViewTopInsets: CGFloat = 64.0
    
    }
    
    
    // MARK: Model
    var delegate:SideBarDelegate?

    // Views
    let sideBarContainerView:UIView = UIView()
    let originView:UIView!
    let sideBarTableViewController:SidebarTableViewController = SidebarTableViewController()

    // State
    var isSideBarOpen:Bool = false
    
    // Animations
    var animator:UIDynamicAnimator!
    
    // Config
    let barWidth:CGFloat = Constants.SidebarConfigSidebarWidth
    let sideBarTableViewTopInset:CGFloat = Constants.SidebarConfigTableViewTopInsets
    
    
    
    // MARK: Initializers
    convenience override init() {
        self.init(sourceView: UIView(), menuItems: [])
    }
    
    init(sourceView:UIView, menuItems:[String]){
        
        originView = sourceView
        sideBarTableViewController.tableData = menuItems

        super.init()

        // Basic Sidebar Setup
        setupSideBar()

        // Setup Gestures
        setupGesturesRecognizers()

        // UIKit Dynamics for Animations
        animator = UIDynamicAnimator(referenceView: originView)
    }
    
    
    
    // MARK: Basic Sidebar Setup
    
    func setupSideBar(){
        
        // Basic setup
        sideBarContainerView.hidden = true
        
        sideBarContainerView.frame = CGRectMake(-barWidth - 1, originView.frame.origin.y, barWidth, originView.frame.size.height)
        sideBarContainerView.backgroundColor = UIColor.clearColor()
        sideBarContainerView.clipsToBounds = false
        
        originView.addSubview(sideBarContainerView)
        
        
        // BlurView effect
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        
        // SidebarTableViewController
        sideBarTableViewController.delegate = self
        
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        sideBarTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideBarTableViewController.tableView.scrollsToTop  = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInset, 0, 0, 0)
        
        sideBarTableViewController.tableView.reloadData()
        
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
        
    }
    

    // MARK: Setup Gestures
    
    func setupGesturesRecognizers () {
        
        // UIScreenEdge Swipe Gestures
        let showGestureEdgeRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgeSwipe:")
        showGestureEdgeRecognizer.edges = UIRectEdge.Left
        showGestureEdgeRecognizer.delegate = self
        originView.addGestureRecognizer(showGestureEdgeRecognizer)
        
        // Right Swipe Gestures
//        let showGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
//        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
//        originView.addGestureRecognizer(showGestureRecognizer)
        
        // Left Swipe Gestures
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(hideGestureRecognizer)
    }

    
    func handleEdgeSwipe(recognizer:UIScreenEdgePanGestureRecognizer) {
    
        // Get the current view we are touching
        let currentView: UIView = originView.hitTest(recognizer.locationInView(recognizer.view), withEvent: nil)!
        
        if recognizer.state == UIGestureRecognizerState.Began {
        
            println("UIEdgePanGesture Recognizer detected")
            if recognizer.edges == UIRectEdge.Left {

                println("UIEdgePanGesture LEFT EDGE detected")

                showSideBar(true)
                delegate?.sideBarWillOpen?()
            }
            
        }
   }
    
    /*
    // Get the current view we are touching
    UIView *view = [self.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    
    if(UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint translation = [gesture translationInView:gesture.view];
        // Move the view's center using the gesture
        view.center = CGPointMake(_centerX + translation.x, view.center.y);
    } else {
    
        // cancel, fail, or ended
        // Animate back to center x
        [UIView animateWithDuration:.3 animations:^{

        view.center = CGPointMake(_centerX, view.center.y);
        }];
    }
    */
    
    
    func handleSwipe(recognizer:UISwipeGestureRecognizer){
        if recognizer.direction == UISwipeGestureRecognizerDirection.Left{
            showSideBar(false)
            delegate?.sideBarWillClose?()
            
        }else{
            showSideBar(true)
            delegate?.sideBarWillOpen?()
        }
    }
    
    
    
    // MARK: Custom Methods
    
    func showSideBar(shouldOpen:Bool){

        isSideBarOpen = shouldOpen
        
        // Animations
        animator.removeAllBehaviors()
        let gravityX:CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitude:CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX:CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        self.sideBarContainerView.hidden = (shouldOpen) ? false : true
        
        // Gravity Behvaior
        let gravityBehavior:UIGravityBehavior = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravityBehavior)
        
        // Collision Behvaior
        let collisionBehavior:UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehavior.addBoundaryWithIdentifier("sideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        // Push Behvaior
        let pushBehavior:UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        
        // Dynamic Elsaticity Behvaior
        let sideBarBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehavior.elasticity = 0.3
        animator.addBehavior(sideBarBehavior)
        
    }
    
    
    // MARK: SidebarTableViewControllerDelegate Protocol
    func sidebarDidSelectRowAtIndexPath(indexPath: NSIndexPath) {
        delegate?.sidebarDidSelectRowAtIndex(indexPath.row)
    }
    
    
}
