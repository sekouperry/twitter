//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Josh Jeong on 4/17/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isFavorited = false
    var isRetweeted = false
    
    var tweet: Tweet! {
        didSet {
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
                retweetCountLabel.text = "\(retweetCount)"
            }
            
            if let favoritesCount = tweet.favoritesCount {
                favoritesCountLabel.text = "\(favoritesCount)"
            }
            
            if let favorited = tweet.favorited {
                isFavorited = favorited
                if favorited {
                    favoriteButton.imageView?.image = #imageLiteral(resourceName: "active-like-button")
                }
            }
            
            if let retweeted = tweet.retweeted {
                isRetweeted = retweeted
                if retweeted {
                    retweetButton.imageView?.image = #imageLiteral(resourceName: "active-retweet-button")
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    
    @IBAction func onRetweet(_ sender: Any) {
        
        if let id = tweet.id {
            if isRetweeted {
                TwitterClient.sharedInstance?.unfavorite(tweetId: id, success: {
                    self.isRetweeted = false
                    self.toggleFavoriteButton(isFavorite: false)
                }, failure: { (error) in
                    
                })
            } else {
                TwitterClient.sharedInstance?.favorite(tweetId: id, success: {
                    self.isRetweeted = true
                    self.toggleFavoriteButton(isFavorite: true)
                }, failure: { (error) in
                    
                })
            }
        }
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
        var currentFavoriteValue = Int(favoritesCountLabel.text!) ?? 0
        
        if isFavorite {
            favoriteButton.imageView?.image = #imageLiteral(resourceName: "active-like-button")
            currentFavoriteValue = currentFavoriteValue + 1
        } else {
            favoriteButton.imageView?.image = #imageLiteral(resourceName: "like-button")
            currentFavoriteValue = currentFavoriteValue - 1
        }
        
        
        favoritesCountLabel.text = "\(currentFavoriteValue)"
    }
    
    func toggleRetweetButton(isRetweeted: Bool) {
        var currentRetweetValue = Int(retweetCountLabel.text!) ?? 0
        
        if isRetweeted {
            retweetButton.imageView?.image = #imageLiteral(resourceName: "active-like-button")
            currentRetweetValue = currentRetweetValue + 1
        } else {
            retweetButton.imageView?.image = #imageLiteral(resourceName: "like-button")
            currentRetweetValue = currentRetweetValue - 1
        }
        
        retweetCountLabel.text = "\(currentRetweetValue)"
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didTapRetweet"), object: nil, userInfo: ["tweet": tweet])
        
    }
    
}
