//
//  MenuViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/21/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var profileVC: ProfileViewController!
    private var timelineVC: TweetsViewController!
    private var mentionsVC: MentionsViewController!
    private var accountsVC: AccountsViewController!
    
    var hamburgerVC: HamburgerViewController!

    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initViewControllers()
    }
    
    func initViewControllers() {
        profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        timelineVC = storyboard?.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        mentionsVC = storyboard?.instantiateViewController(withIdentifier: "MentionsViewController") as! MentionsViewController
        accountsVC = storyboard?.instantiateViewController(withIdentifier: "AccountsViewController") as! AccountsViewController
        
        viewControllers.append(profileVC)
        viewControllers.append(timelineVC)
        viewControllers.append(mentionsVC)
        viewControllers.append(accountsVC)
        
        hamburgerVC.contentVC = timelineVC
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let titles = ["Profile", "Timeline", "Mentions", "Accounts"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerVC.contentVC = viewControllers[indexPath.row]
    }
    
}
