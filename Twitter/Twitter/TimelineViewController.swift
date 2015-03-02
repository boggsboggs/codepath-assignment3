//
//  TimelineViewController.swift
//  Twitter
//
//  Created by John Boggs on 2/18/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit



class TimelineViewController: UIViewController, LoginViewControllerDelegate, TweetCellDelegate {

//    let TWEET_CELL_IDENTIFIER = "TweetCellIdentifier"
    let LOGIN_SEGUE = "LoginViewController"
    let DETAIL_SEGUE = "DetailViewController"
    let REPLY_SEGUE = "replySegue"
    let PROFILE_SEGUE = "ProfileSegue"

    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tableView: UITableView!
    
    var timelineTable : TimelineTable!
    var tweets : [Tweet] = []
    
    @IBAction func signOutPressed(sender: AnyObject) {
        defaults.setBool(false, forKey: LOGGED_IN_KEY)
        self.performSegueWithIdentifier(LOGIN_SEGUE, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timelineTable = TimelineTable(
            mode: "TimelineMode",
            tableView: self.tableView,
            viewController: self,
            tweetCellDelegate: self
        )
        self.timelineTable.initialize()
        tableView.delegate = timelineTable; tableView.dataSource = timelineTable
    }
    
    override func viewWillAppear(animated: Bool) {
        self.timelineTable.refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if defaults.boolForKey(LOGGED_IN_KEY) {
            println("already logged in: \(TwitterClient.instance.requestSerializer.accessToken.token)")
        } else {
            self.performSegueWithIdentifier(LOGIN_SEGUE, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == LOGIN_SEGUE {
                (segue.destinationViewController as LoginViewController).delegate = self
            } else if identifier == DETAIL_SEGUE {
                println("prepare for detail segue")
                let tweet = (sender as TweetCell).tweet
                let detailViewController = (segue.destinationViewController as TweetViewController)
                detailViewController.tweet = tweet
            } else if identifier == REPLY_SEGUE {
                let navVC = segue.destinationViewController as UINavigationController
                let composeVC = navVC.topViewController as ComposeViewController
                let tweetCell = sender as TweetCell
                composeVC.replyTweet = tweetCell.tweet!
            } else if identifier == PROFILE_SEGUE {
                let profileVC = segue.destinationViewController as ProfileViewController
                let tweetCell = sender as TweetCell
                profileVC.fetchHandle = tweetCell.tweet?.handle
            }
        }
    }
    
    func dismissModal() {
        self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
    }

    func peformReplySegue(tweetCell: TweetCell) {
        self.performSegueWithIdentifier(REPLY_SEGUE, sender: tweetCell)
    }
    
    func segueToProfile(tweetCell: TweetCell) {
        self.performSegueWithIdentifier(PROFILE_SEGUE, sender: tweetCell)
    }
}