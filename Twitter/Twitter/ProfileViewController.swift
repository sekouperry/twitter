//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/21/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var tweets = [Tweet]()
    var profileCell: ProfileTableViewCell?
    var originalScrollPosition: CGFloat?
    var user = User.currentUser
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        refreshControl.addTarget(self, action: #selector(self.refreshTableData(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        refreshTableData(refreshControl)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didTapRetweet"), object: nil, queue: OperationQueue.main) { (notification) in
            if let tweet = notification.userInfo?["tweet"] as? Tweet {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
                vc.tweet = tweet
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshTableData(_ refreshControl: UIRefreshControl) {
        print((user?.screenname!)!)
        
        TwitterClient.sharedInstance?.userTimeLine(screenName: (user?.screenname!)!,success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error) in
            
        })
        refreshControl.endRefreshing()
    }
    
    @IBAction func onShowComposeViewController(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.selectionStyle = .none
            cell.user = user
            profileCell = cell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        
        cell.tweet = tweets[indexPath.row - 1]
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.tweet = tweets[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if originalScrollPosition == nil {
            originalScrollPosition = scrollView.contentOffset.y
        }
        
        if let profileCell = profileCell,
            let bannerOriginalHeight = profileCell.bannerOriginalHeight{

            var delta = originalScrollPosition! - scrollView.contentOffset.y
            
            if delta > 0 {
                profileCell.bannerHeightConstraint.constant =
                            bannerOriginalHeight + delta
                print(bannerOriginalHeight + delta)
                profileCell.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let profileCell = profileCell,
            let bannerOriginalHeight = profileCell.bannerOriginalHeight{
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.profileCell?.bannerHeightConstraint.constant = (self.profileCell?.bannerOriginalHeight)!
            })
        }
    }
}
