//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/17/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser!
        tweetTextField.delegate = self
        if let avatarImageUrl = user.profileUrl {
            avatarImageView.setImageWith(avatarImageUrl)
        }
        
        if let name = user.name {
            nameLabel.text = name
        }
        
        if let username = user.screenname {
            usernameLabel.text = "@\(username)"
        }
        
        if let tweetUsername = tweet?.username {
            tweetTextField.text = "@\(tweetUsername) "
        }
        
        tweetTextField.becomeFirstResponder()
    }
}

extension ComposeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var message = tweetTextField.text!
        var replyTweetId: Int?
        if let replyId = tweet?.id {
            replyTweetId = replyId
        }
        
        TwitterClient.sharedInstance?.tweet(message: tweetTextField.text!, replyTweetId: replyTweetId, success: {
            self.navigationController?.popViewController(animated: true)
        }, failure: { (error) in
            
        })
        return true
    }
}
