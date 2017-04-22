//
//  TwitterClient.swift
//  Twitter
//
//  Created by Josh Jeong on 4/16/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "WhJxxw8NtuNBKEM484zKuj1Fy", consumerSecret: "KNOlyP5VtU3NUSKvC6bEvJAWB6PoM9nUfFjREAcfOTCTAE5ozI")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure

        deauthorize()
        fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: {
            (requestToken) -> Void in
            
            if let requestToken = requestToken {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
                UIApplication.shared.open(url!)
            }
        }, failure: {
            (error) -> Void in
            print(error?.localizedDescription)
            self.loginFailure?(error as! NSError)
        })
    }
    
    func logout(success: () -> ()) {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        success()
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "/oauth/access_token", method: "POST", requestToken: requestToken, success: {
            (accessToken) -> Void in
            
            
            
            self.currentAccount(success: { (user) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error) in
                self.loginFailure?(error as NSError)
            })
            
        }, failure: {
            (error) -> Void in
            print(error?.localizedDescription)
            self.loginFailure?(error as! NSError)
        })

    }
    
    func userTimeLine(screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/user_timeline.json?screen_name=\(screenName)", parameters: nil, progress: nil, success: { (task, response) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task, error) -> Void in
            print("unable to retrieve users timeline")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task, error) -> Void in
            print("unable to retrieve timeline")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func mentionsTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task, error) -> Void in
            print("unable to retrieve timeline")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func getUser(screenName: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        print(screenName)
        get("1.1/users/show.json?screen_name=\(screenName)", parameters: nil, progress: nil, success: { (task, response) -> Void in
            
            let dictionary = response as! NSDictionary
            let user = User(dictionary: dictionary)
            success(user)
        }, failure: { (task, error) -> Void in
            print("unable to retrieve user")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            let userDictionary = response as? NSDictionary
            if let userDictionary = userDictionary {
                let user = User(dictionary: userDictionary)
                success(user)
            }
        }, failure: {(task, error) -> Void in
            print("unable to verify credentials")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func favorite(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params = ["id" : "\(tweetId)"]
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task, response) -> Void in
            print("favorite successful")
            success()
            
        }, failure: {(task, error) -> Void in
            print("unable to favorite")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func unfavorite(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params = ["id" : "\(tweetId)"]
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task, response) -> Void in
            print("unfavorite successful")
            success()
            
        }, failure: {(task, error) -> Void in
            print("unable to unfavorite")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func tweet(message: String, replyTweetId: Int?, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        var params = ["status": message]
        
        if let replyId = replyTweetId {
            params["in_reply_to_status_id"] = "\(replyId)"
        }
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task, response) -> Void in
            print("new tweet successful")
            success()
            
        }, failure: {(task, error) -> Void in
            print("unable to post new tweet")
            print(error.localizedDescription)
            failure(error)
        })
    }
}
