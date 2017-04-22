//
//  Tweet.swift
//  Twitter
//
//  Created by Josh Jeong on 4/16/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit
import ObjectMapper

class Tweet: Mappable {
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    var retweetCount: Int? = 0
    var favoritesCount: Int? = 0
    var mediaUrl: URL?
    var profileImageThumbnail: URL?
    var name: String?
    var username: String?
    var timeAgo: String?
    var id: Int?
    var favorited: Bool?
    var retweeted: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        text                  <- map["text"]
        retweetCount          <- map["retweet_count"]
        favoritesCount        <- map["favorite_count"]
        mediaUrl              <- (map["extended_entities.media.0.media_url"], URLTransform())
        profileImageThumbnail <- (map["user.profile_image_url_https"], URLTransform())
        name                  <- map["user.name"]
        username              <- map["user.screen_name"]
        createdAtString       <- map["created_at"]
        id                    <- map["id"]
        favorited             <- map["favorited"]
        retweeted             <- map["retweeted"]
        convertToDate()
        calculateTimeAgo()
    }
        
    func convertToDate() {
        if let createdAtString = createdAtString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: createdAtString)
        }
    }
    
    func calculateTimeAgo() {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.second, .minute, .hour, .day, .month, .year]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        let timeDiff = dateComponentsFormatter.string(from: createdAt!, to: Date())
        timeAgo = timeDiff
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dictionary,
                options: []) {
                let jsonString = String(data: theJSONData,
                                        encoding: .ascii)
                if let jsonString = jsonString {
                    let tweet = Tweet(JSONString: jsonString)
                    tweets.append(tweet!)
                }
            }
        }
        return tweets
    }
    
}
