//
//  TweetCell.swift
//  Twitter
//
//  Created by John Boggs on 2/18/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    var tweet : Tweet?
    
    var delegate : TweetCellDelegate?
    
    let REPLY_SEGUE = "replySegue"
    
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        delegate?.peformReplySegue(self)
    }
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        TwitterClient.instance.sendTweet(tweet!.text)
        setRetweeted()
    }
    
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        TwitterClient.instance.favoriteTweet(tweet!)
        self.setFavorited()
    }
    
    @IBOutlet weak var tweetText: UITextView!
    
    func setFavorited() {
        let favoritedImage = UIImage(named: "favorite_on.png")
        favoriteButton.setBackgroundImage(favoritedImage, forState: UIControlState.Normal)
    }
    
    func setRetweeted() {
        let retweetedImage = UIImage(named: "retweet_on.png")
        retweetButton.setBackgroundImage(retweetedImage, forState: UIControlState.Normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initializeContent() {
        self.tweetText.text = tweet!.text
        if tweet!.favorited {
            setFavorited()
        }
        if tweet!.retweeted {
            setRetweeted()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol TweetCellDelegate {
    func peformReplySegue(tweetCell: TweetCell)
}
