//
//  TimelineTable.swift
//  Twitter
//
//  Created by John Boggs on 3/1/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import Foundation

class TimelineTable : NSObject, UITableViewDataSource, UITableViewDelegate {
    let TWEET_CELL_IDENTIFIER = "TweetCellIdentifier"
    let DETAIL_SEGUE = "DetailViewController"

    let PROFILE_MODE = "ProfileMode"
    let TIMELINE_MODE = "TimelineMode"
    let MENTIONS_MODE = "MentionsMode"
    var mode : String
    
    var user : String?
    
    var tableView : UITableView
    var viewController : UIViewController
    var tweetCellDelegate : TweetCellDelegate
    var refreshControl : UIRefreshControl
    
    
    
    init(mode: String, tableView : UITableView, viewController: UIViewController, tweetCellDelegate: TweetCellDelegate) {
        self.mode = mode
        self.tableView = tableView
        self.viewController = viewController
        self.tweetCellDelegate = tweetCellDelegate
        self.refreshControl = UIRefreshControl()

    }
    
    func initialize() {
        self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: TWEET_CELL_IDENTIFIER)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }

    var tweets : [Tweet] = []
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.TWEET_CELL_IDENTIFIER) as TweetCell
        cell.tweet = self.tweets[indexPath.row]
        cell.initializeContent()
        cell.delegate = self.tweetCellDelegate
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("selected")
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.viewController.performSegueWithIdentifier(DETAIL_SEGUE, sender: self.tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func getTweets(callback: ([Tweet]?, NSError?) -> ()) {
        if self.mode == TIMELINE_MODE {
            TwitterClient.instance.getTweets(callback)
        } else if self.mode == PROFILE_MODE {
            if let user = user {
                TwitterClient.instance.getUserTweets(
                    user,
                    success: callback
                )
            }

        } else if self.mode == MENTIONS_MODE {
            TwitterClient.instance.getMentions(callback)
        }

    }
    
    func getHeaderView() -> UIView? {
        return nil
    }

    func refreshData() {
        
        self.getTweets { (tweets: [Tweet]?, error: NSError?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
            if let error = error {
                println("error: \(error)")
            }
            self.refreshControl.endRefreshing()
        }
    }
    
}