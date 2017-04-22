//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Josh Jeong on 4/22/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!

    var bannerOriginalHeight: CGFloat?
    var user: User! {
        didSet {
            if let bannerImageUrl = user.bannerImageUrl {
                bannerImageView.setImageWith(bannerImageUrl)
            }
            if let profileUrl = user.profileUrl {
                profileImageView.setImageWith(profileUrl)
            }
            if let name = user.name {
                userNameLabel.text = name
            }
            if let screenName = user.screenname {
                screenNameLabel.text = screenName
            }
            if let tweetsCount = user.statusesCount {
                tweetsCountLabel.text = "\(tweetsCount)"
            }
            if let followingCount = user.friendsCount {
                followingCountLabel.text = "\(followingCount)"
            }
            if let followersCount = user.followersCount {
                followersCountLabel.text = "\(followersCount)"
            }
            
            
            bannerOriginalHeight = bannerHeightConstraint.constant
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
