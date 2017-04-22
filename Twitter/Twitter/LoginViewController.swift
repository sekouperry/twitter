//
//  LoginViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/14/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLoginButton(_ sender: UIButton) {
        TwitterClient.sharedInstance?.login(success: {
            print("successfully logged in")
            let hamburgerVC = self.storyboard?.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
            let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuVC.hamburgerVC = hamburgerVC
            hamburgerVC.menuVC = menuVC
            self.present(hamburgerVC, animated: true, completion: nil)
        }, failure: { (error) in
            print("Error while logging in")
            print(error.localizedDescription)
        })
    }
}

