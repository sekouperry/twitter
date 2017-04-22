//
//  User.swift
//  Twitter
//
//  Created by Josh Jeong on 4/16/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var bannerImageUrl: URL?
    var followersCount: Int?
    var friendsCount: Int?
    var statusesCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int

        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let bannerUrlString = dictionary["profile_banner_url"] as? String
        if let bannerUrlString = bannerUrlString {
            bannerImageUrl = URL(string: bannerUrlString + "/mobile")
        }
        
        
        
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    
                    let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    if let dictionary = dictionary {
                        _currentUser = User(dictionary: dictionary)
                    }
                } else {
                    print("user data is nil")
                }
            }
            
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
                
            } else {
                print("unable to set user. user is nil")
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
