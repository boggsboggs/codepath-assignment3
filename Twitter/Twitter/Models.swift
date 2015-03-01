//
//  Models.swift
//  Twitter
//
//  Created by John Boggs on 2/18/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import Foundation


struct Tweet {
    var id : String
    var profileImage : String
    var name : String
    var handle : String
    var text : String
    var favorited : Bool
    var retweeted : Bool
    var createdAt : String
    
    static func reformatTimestamp(apiTimestamp: String) -> String {
        let apiFormatter = NSDateFormatter()
        apiFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        let date = apiFormatter.dateFromString(apiTimestamp)

        let uiFormatter = NSDateFormatter()
        uiFormatter.dateStyle = .ShortStyle
        uiFormatter.timeStyle = .ShortStyle
        return uiFormatter.stringFromDate(date!)
    }
    
    static func fromJSON(tweetJson : NSDictionary) -> Tweet {
        return Tweet(
            id: tweetJson.valueForKeyPath("id_str")! as String,
            profileImage: tweetJson.valueForKeyPath("user.profile_image_url")! as String,
            name: tweetJson.valueForKeyPath("user.name")! as String,
            handle: tweetJson.valueForKeyPath("user.screen_name")! as String,
            text: tweetJson.valueForKeyPath("text")! as String,
            favorited: tweetJson.valueForKeyPath("favorited")! as Bool,
            retweeted: tweetJson.valueForKeyPath("retweeted")! as Bool,
            createdAt: Tweet.reformatTimestamp(tweetJson.valueForKeyPath("created_at")! as String)
        )
    }
}

struct User {
    var name: String
    var handle: String
    var profileImageUrl: NSURL
    var backgroundImageUrl: NSURL
    var tweetCount: Int
    var followersCount: Int
    var followingCount: Int

    static func fromJSON(userJson : NSDictionary) -> User {
        return User(
            name: userJson["name"]! as String,
            handle: userJson["screen_name"]! as String,
            profileImageUrl: NSURL(string: userJson["profile_image_url"]! as String)!,
            backgroundImageUrl: NSURL(string: userJson["profile_banner_url"]! as String)!,
            tweetCount: userJson["statuses_count"]! as Int,
            followersCount: userJson["followers_count"]! as Int,
            followingCount: userJson["friends_count"]! as Int
        )
    }
}