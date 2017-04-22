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
    
    private var profileVC: UIViewController!
    private var timelineVC: UIViewController!
    private var mentionsVC: UIViewController!
    private var accountsVC: UIViewController!
    
    var hamburgerVC: HamburgerViewController!

    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        initViewControllers()
        tableView.rowHeight = view.frame.size.height / CGFloat(viewControllers.count)
    }
    
    func initViewControllers() {
        profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileNavigationVC")
        timelineVC = storyboard?.instantiateViewController(withIdentifier: "TweetsNavigationVC")
        mentionsVC = storyboard?.instantiateViewController(withIdentifier: "MentionsNavigationVC")
        accountsVC = storyboard?.instantiateViewController(withIdentifier: "AccountsNavigationVC")
        
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
        cell.selectionStyle = .none
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
