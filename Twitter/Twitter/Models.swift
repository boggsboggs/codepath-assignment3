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
    
    static func fromJSON(tweetJson : NSDictionary) -> Tweet {
        return Tweet(
            id: tweetJson.valueForKeyPath("id_str")! as String,
            profileImage: tweetJson.valueForKeyPath("user.profile_image_url")! as String,
            name: tweetJson.valueForKeyPath("user.name")! as String,
            handle: tweetJson.valueForKeyPath("user.screen_name")! as String,
            text: tweetJson.valueForKeyPath("text")! as String,
            favorited: tweetJson.valueForKeyPath("favorited")! as Bool,
            retweeted: tweetJson.valueForKeyPath("retweeted")! as Bool,
            createdAt: tweetJson.valueForKeyPath("created_at")! as String
        )
    }
}

struct User {
    var name: String
}