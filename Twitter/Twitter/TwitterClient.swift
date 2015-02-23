//
//  TwitterClient.swift
//  Twitter
//
//  Created by John Boggs on 2/21/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

class TwitterClient: BDBOAuth1RequestOperationManager {
    let defaults = NSUserDefaults.standardUserDefaults()
    let LOGIN_URL_KEY = "LoginUrl"
    
    var loginCallback = { ( user : User?, error : NSError?) in
        NSLog("loginCallback called before being set.  User: \(user), Error: \(error)")
    }
    
    class var instance : TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: NSURL(string: "https://api.twitter.com"),
                consumerKey: "SZQErJmn3yveZfTaeiP7recyW",
                consumerSecret: "vlw9AMVltJSiBFpgeyBQD4ShbXid3DWDj7my3mxF5ALpTg7PPe"
            )
        }
        return Static.instance
    }

    func getTweets(success : ([Tweet]?, NSError?) -> ()) {
        self.GET(
            "https://api.twitter.com/1.1/statuses/home_timeline.json",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let tweets = (response! as Array).map({ (tweetJson) in
                    Tweet.fromJSON(tweetJson as NSDictionary)
                })
                success(tweets, nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error fetching tweets: \(error)")
            })
    }

    func sendTweet(tweet : String) {
        NSLog("tweeting: \(tweet)")
        self.backingSendTweet(tweet, replyToTweet: nil)
    }

    func backingSendTweet(tweet : String, replyToTweet : Tweet?) {
        var parameters = [
                "status": tweet,
        ]
        if let replyToTweet = replyToTweet {
            let status = "@\(replyToTweet.handle) \(tweet)"
            parameters = [
                "status": status,
                "in_reply_to_status_id": replyToTweet.id
            ]
        }
        self.POST(
            "https://api.twitter.com/1.1/statuses/update.json",
            parameters: parameters,
            constructingBodyWithBlock: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("successfully tweeted")
            }) { (operation : AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("failed to tweet: \(error)")
        }
    }
    
    func sendTweet(tweet : String, inReplyTo originalTweet : Tweet) {
        NSLog("tweeting: \(tweet), in reply to \(originalTweet.text)")
        self.backingSendTweet(tweet, replyToTweet: originalTweet)
    }
    
    func favoriteTweet(tweet : Tweet) {
        NSLog("Favoriting: \(tweet.text)")
        self.POST(
            "https://api.twitter.com/1.1/favorites/create.json",
            parameters: [
                "id": tweet.id
            ],
            constructingBodyWithBlock: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("successfully favorited")
            }) { (operation : AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("failed to favorite: \(error)")
        }
    }
    
    func oauthLogin() {
        NSLog("oauthLogin")
        self.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "codepathtwitter://oauth"),
            scope: nil,
            success: {(requestToken: BDBOAuthToken!) in
                NSLog("oauthLogin success")
                let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(authUrl)
            },
            failure: {(error: NSError!) in
                NSLog("oauthLogin error")
                self.loginCallback(nil, error)
            }
        )
    }
    
    func openURL(url: NSURL) {
        defaults.setURL(url, forKey: LOGIN_URL_KEY)
        let requestToken = BDBOAuthToken(queryString: url.query)
        
        self.fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: BDBOAuthToken!) in
                self.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.instance.GET(
                    "https://api.twitter.com/1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) in
                        println(response)
                        let user = User(name: response["screen_name"]! as String)
                        self.loginCallback(user, nil)
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        self.loginCallback(nil, error)
                })
            },
            failure: { (error: NSError!) in
                self.loginCallback(nil, error)
            }
        )
    }
}
