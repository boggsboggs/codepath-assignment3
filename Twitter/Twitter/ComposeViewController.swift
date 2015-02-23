//
//  ComposeViewController.swift
//  Twitter
//
//  Created by John Boggs on 2/22/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    var replyTweet : Tweet?
    
    @IBAction func cancelPressed(sender: AnyObject) {
        NSLog("cancel pressed")
        self.parentViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetPressed(sender: AnyObject) {
        NSLog("cancel pressed")
        let tweet = tweetTextView.text
        if let replyTweet = replyTweet {
            TwitterClient.instance.sendTweet(tweet, inReplyTo : replyTweet)
        } else {
            TwitterClient.instance.sendTweet(tweet)
        }
        
        tweetTextView.text = ""
        replyTweet = nil
        self.parentViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        self.tweetTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
