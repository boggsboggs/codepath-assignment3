//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by John Boggs on 3/1/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let PROFILE_VC_IDENFITIER = "ProfileIdentifier"
    let TIMELINE_VC_IDENTIFIER = "TimelineIdentifier"
    let MENTIONS_VC_IDENTIFIER = "MentionsIdentifier"
    let TIMELINE_NAV_VC_IDENTIFIER = "TimelineNavIdentifier"
    
    let HAMBURGER_CELL_IDENTIFIER = "HamburgerCell"
    
    let PROFILE_IDX = 0
    let TIMELINE_IDX = 1
    let MENTIONS_IDX = 2
    
    let HAMBURGER_MENU_WIDTH : CGFloat = 200.0
    
    var currentVC : UIViewController!
    var vcs : [UIViewController]!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leftSideTableViewConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self; self.tableView.dataSource = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//      Profile VC
        let profileNavVC = storyboard.instantiateViewControllerWithIdentifier(TIMELINE_NAV_VC_IDENTIFIER) as UINavigationController
        let profileVC = storyboard.instantiateViewControllerWithIdentifier(PROFILE_VC_IDENFITIER) as ProfileViewController
        profileNavVC.viewControllers = [profileVC]
        
//      Timeline VCn
        let timelineNavVC = storyboard.instantiateViewControllerWithIdentifier(TIMELINE_NAV_VC_IDENTIFIER) as UINavigationController
        let timelineVC = storyboard.instantiateViewControllerWithIdentifier(TIMELINE_VC_IDENTIFIER) as TimelineViewController
        timelineNavVC.viewControllers = [timelineVC]

//      Mentions VC
        let mentionsNavVC = storyboard.instantiateViewControllerWithIdentifier(TIMELINE_NAV_VC_IDENTIFIER) as UINavigationController
        let mentionsVC = storyboard.instantiateViewControllerWithIdentifier(MENTIONS_VC_IDENTIFIER) as MentionsViewController
        mentionsNavVC.viewControllers = [mentionsVC]
        
        self.vcs = [profileNavVC, timelineNavVC, mentionsNavVC]
        self.updateCurrentView(timelineNavVC)
    }
    
    func updateCurrentView(vc : UIViewController) {
        self.currentVC = vc
        self.contentView.addSubview(self.currentVC.view)
        self.currentVC.view.frame = self.contentView.bounds
    }
    
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.Right {
            self.moveHamburgerMenu(true, completion: nil)
        } else if sender.direction == UISwipeGestureRecognizerDirection.Left {
            self.moveHamburgerMenu(false, completion: nil)
        }
        
    }
    
    func moveHamburgerMenu(open : Bool, completion: (() -> ())?) {
        var constraintValue : CGFloat!
        if open {
            constraintValue = 0
        } else {
            constraintValue = -1 * HAMBURGER_MENU_WIDTH
        }
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(
            0.6,
            animations: {
                self.leftSideTableViewConstraint.constant = constraintValue
                self.view.layoutIfNeeded()
            },
            completion: { complete in
                if complete {
                    completion?()
                }
            }
        )
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let newVC = self.vcs[indexPath.row]
        self.moveHamburgerMenu(false, nil)
        self.updateCurrentView(newVC)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(HAMBURGER_CELL_IDENTIFIER) as HamburgerCell
        let row = indexPath.row
        if row == PROFILE_IDX {
            cell.cellLabel.text = "PROFILE"
        } else if row == TIMELINE_IDX {
            cell.cellLabel.text = "TIMELINE"
        } else if row == MENTIONS_IDX {
            cell.cellLabel.text = "MENTIONS"
        }
        
        return cell
    }
    
}
