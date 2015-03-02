//
//  MentionsViewController.swift
//  Twitter
//
//  Created by John Boggs on 3/1/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, TweetCellDelegate {
    let REPLY_SEGUE = "replySegue"
    let PROFILE_SEGUE = "ProfileSegue"
    
    @IBOutlet weak var tableView: UITableView!
    var timelineTable : TimelineTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timelineTable = TimelineTable(
            mode: "MentionsMode",
            tableView: self.tableView,
            viewController: self,
            tweetCellDelegate: self
        )
        timelineTable.initialize()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.timelineTable.refreshData()
    }
    
    func peformReplySegue(tweetCell: TweetCell) {
        self.performSegueWithIdentifier(REPLY_SEGUE, sender: tweetCell)
    }
    
    func segueToProfile(tweetCell: TweetCell) {
        self.performSegueWithIdentifier(PROFILE_SEGUE, sender: tweetCell)
    }
}
