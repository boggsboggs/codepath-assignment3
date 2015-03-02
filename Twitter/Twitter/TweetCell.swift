//
//  TweetCell.swift
//  Twitter
//
//  Created by John Boggs on 2/18/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    // Vars
    var tweet : Tweet?
    var delegate : TweetCellDelegate?
    let REPLY_SEGUE = "replySegue"
    
    // Buttons
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
    
    // Outlets
    @IBOutlet weak var tweetText: UITextView!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var timestampLabel: UILabel!

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
        self.profileImageView.setImageWithURL(NSURL(string: tweet!.profileImage))
        self.profileImageView.layer.cornerRadius = 5.0
        self.profileImageView.layer.masksToBounds = true
        self.handleLabel.text = "@\(tweet!.handle)"
        self.timestampLabel.text = tweet!.createdAt
        if tweet!.favorited {
            setFavorited()
        }
        if tweet!.retweeted {
            setRetweeted()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "profileTapped")
        self.profileImageView.addGestureRecognizer(tapGesture)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func profileTapped() {
        self.delegate?.segueToProfile(self)
    }

}

protocol TweetCellDelegate {
    func peformReplySegue(tweetCell: TweetCell)
    func segueToProfile(tweetCell: TweetCell)
}
