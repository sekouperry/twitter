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
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error) in
            print("Error while logging in")
            print(error.localizedDescription)
        })
    }
}

