//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/21/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var tweets = [Tweet]()
    
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
        TwitterClient.sharedInstance?.mentionsTimeLine(success: { (tweets) in
            
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

extension MentionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.tweet = tweets[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
