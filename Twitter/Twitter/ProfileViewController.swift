//
//  ProfileViewController.swift
//  Twitter
//
//  Created by John Boggs on 2/28/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var tweets: UILabel!
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    var fetchHandle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.instance.getUser(self.fetchHandle!, callback: { (user: User?, error: NSError?) -> () in
            if let user = user {
                self.profileImage.setImageWithURL(user.profileImageUrl)
                self.backgroundImage.setImageWithURL(user.backgroundImageUrl)
                self.nameLabel.text = user.name
                self.handleLabel.text = "@\(user.handle)"
                self.tweets.text = String(user.tweetCount)
                self.followers.text = String(user.followersCount)
                self.following.text = String(user.followingCount)
            }
        })

    }
    
    
}
