//
//  TweetViewController.swift
//  Twitter
//
//  Created by John Boggs on 2/18/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    let REPLY_SEGUE = "ReplySegue"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetText: UITextView!
    
    @IBOutlet weak var retweetButton: UIButton!

    @IBOutlet weak var favoriteButton: UIButton!

    @IBAction func retweetButtonPressed(sender: AnyObject) {
        TwitterClient.instance.sendTweet(tweet!.text)
        setRetweeted()
    }
    

    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        TwitterClient.instance.favoriteTweet(tweet!)
        setFavorited()
    }
    
    var tweet : Tweet?
    
    func setFavorited() {
        let favoritedImage = UIImage(named: "favorite_on.png")
        favoriteButton.setBackgroundImage(favoritedImage, forState: UIControlState.Normal)
        
    }
    
    func setRetweeted() {
        let retweetedImage = UIImage(named: "retweet_on.png")
        retweetButton.setBackgroundImage(retweetedImage, forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = tweet!.name
        tweetText.text = tweet!.text
        
        if tweet!.favorited {
            setFavorited()
        }
        if tweet!.retweeted {
            setRetweeted()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            if identifier == REPLY_SEGUE {
                let navVC = segue.destinationViewController as UINavigationController
                let composeVC = navVC.topViewController as ComposeViewController
                composeVC.replyTweet = tweet
            }
        }
    }
}
