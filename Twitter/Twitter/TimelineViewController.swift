//
//  TimelineViewController.swift
//  Twitter
//
//  Created by John Boggs on 2/18/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit



class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginViewControllerDelegate, TweetCellDelegate {

    let TWEET_CELL_IDENTIFIER = "TweetCellIdentifier"
    let LOGIN_SEGUE = "LoginViewController"
    let DETAIL_SEGUE = "DetailViewController"
    let REPLY_SEGUE = "replySegue"
    let PROFILE_SEGUE = "ProfileSegue"

    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl : UIRefreshControl?
    
    
    var tweets : [Tweet] = []
    
    @IBAction func signOutPressed(sender: AnyObject) {
        defaults.setBool(false, forKey: LOGGED_IN_KEY)
        self.performSegueWithIdentifier(LOGIN_SEGUE, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self; tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshData()
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
                let gestureRecognizer = sender as UITapGestureRecognizer
                let tweetCell = gestureRecognizer.view!.superview!.superview!.superview!.superview!.superview! as TweetCell
                profileVC.fetchHandle = tweetCell.tweet?.handle
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.TWEET_CELL_IDENTIFIER) as TweetCell
        cell.tweet = self.tweets[indexPath.row]
        cell.initializeContent()
        cell.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("selected")
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(DETAIL_SEGUE, sender: self.tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func refreshData() {
        TwitterClient.instance.getTweets { (tweets: [Tweet]?, error: NSError?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
            if let error = error {
                println("error: \(error)")
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    func dismissModal() {
        self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
    }

    func peformReplySegue(tweetCell: TweetCell) {
        self.performSegueWithIdentifier(REPLY_SEGUE, sender: tweetCell)
    }
}