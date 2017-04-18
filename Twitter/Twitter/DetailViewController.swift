//
//  DetailViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/17/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var tweet: Tweet!
    var isFavorited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let avatarImageUrl = tweet.profileImageThumbnail {
            avatarImageView.setImageWith(avatarImageUrl)
        }
        
        if let name = tweet.name {
            nameLabel.text = name
        }
        
        if let username = tweet.username {
            usernameLabel.text = "@\(username)"
        }
        
        if let timeAgo = tweet.timeAgo {
            timeLabel.text = timeAgo
        }
        
        if let tweetText = tweet.text {
            tweetTextLabel.text = tweetText
        }
        
        if let retweetCount = tweet.retweetCount {
            retweetsLabel.text = "\(retweetCount)"
        }
        
        if let favoritesCount = tweet.favoritesCount {
            favoritesLabel.text = "\(favoritesCount)"
        }
        
        if let favorited = tweet.favorited {
            isFavorited = favorited
            if favorited {
                favoriteButton.imageView?.image = #imageLiteral(resourceName: "active-like-button")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavoriteTweet(_ sender: Any) {
        if let id = tweet.id {
            if isFavorited {
                TwitterClient.sharedInstance?.unfavorite(tweetId: id, success: {
                    self.isFavorited = false
                    self.toggleFavoriteButton(isFavorite: false)
                }, failure: { (error) in
                    
                })
            } else {
                TwitterClient.sharedInstance?.favorite(tweetId: id, success: {
                    self.isFavorited = true
                    self.toggleFavoriteButton(isFavorite: true)
                }, failure: { (error) in
                    
                })
            }
        }
    }
    
    func toggleFavoriteButton(isFavorite: Bool) {
        var currentFavoriteValue = Int(favoritesLabel.text!) ?? 0
        
        if isFavorite {
            favoriteButton.imageView?.image = #imageLiteral(resourceName: "active-like-button")
            currentFavoriteValue = currentFavoriteValue + 1
        } else {
            favoriteButton.imageView?.image = #imageLiteral(resourceName: "like-button")
            currentFavoriteValue = currentFavoriteValue - 1
        }
        
        favoritesLabel.text = "\(currentFavoriteValue)"
    }
    @IBAction func onReplyButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didTapRetweet"), object: nil, userInfo: ["tweet": tweet])
    }
}
