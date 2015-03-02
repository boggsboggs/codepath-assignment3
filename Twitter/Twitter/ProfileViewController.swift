//
//  ProfileViewController.swift
//  Twitter
//
//  Created by John Boggs on 2/28/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let TIMELINE_VC_IDENTIFIER = "TimelineIdentifier"

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var tweets: UILabel!
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var tableHeaderView: UIView!
    var fetchHandle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var handle : String!
        if let fetchHandle = self.fetchHandle {
            TwitterClient.instance.getUser(fetchHandle, callback: { (user: User?, error: NSError?) -> () in
                if let user = user {
                    self.initializeFromUser(user)
                }
            })
            self.fetchHandle = nil
        }
        else {
            TwitterClient.instance.getLoggedInUser() { (user: User?, error: NSError?) -> () in
                if let user = user {
                    self.initializeFromUser(user)
                }
            }
        }
    }
    
    func initializeFromUser(user : User) {
        self.profileImage.setImageWithURL(user.profileImageUrl)
        self.backgroundImage.setImageWithURL(user.backgroundImageUrl)
        self.nameLabel.text = user.name
        self.handleLabel.text = "@\(user.handle)"
        self.tweets.text = String(user.tweetCount)
        self.followers.text = String(user.followersCount)
        self.following.text = String(user.followingCount)
    }
    
    
}
