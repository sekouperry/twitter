//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/16/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        let refreshControl = UIRefreshControl()
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
        TwitterClient.sharedInstance?.logout()
    }
    
    func refreshTableData(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            self.tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            self.tableView.reloadData()
        }, failure: { (task, error) -> Void in
            print("unable to retrieve timeline")
            print(error.localizedDescription)
        })
        refreshControl.endRefreshing()
    }
    
    @IBAction func onShowComposeViewController(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
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
