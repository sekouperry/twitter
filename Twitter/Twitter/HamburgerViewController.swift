//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Josh Jeong on 4/21/17.
//  Copyright © 2017 JoshJeong. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    var originalLeftMargin: CGFloat!
    var menuVC: MenuViewController! {
        didSet {
            view.layoutIfNeeded() // will run viewDidLoad
            menuView.addSubview(menuVC.view)
        }
    }
    
    var contentVC: UIViewController! {
        didSet(oldContentVC) {
            view.layoutIfNeeded()
            
            if oldContentVC != nil {
                oldContentVC.willMove(toParentViewController: nil)
                oldContentVC.view.removeFromSuperview()
                oldContentVC.didMove(toParentViewController: nil)
            }
            
            contentVC.willMove(toParentViewController: self)
            contentView.addSubview(contentVC.view)
            contentVC.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case .began:
            originalLeftMargin = leftMarginConstraint.constant
            break
        case .changed:
            if translation.x < 0 { break }
            
            leftMarginConstraint.constant = originalLeftMargin + translation.x
            break
        case .ended:
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 200
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
            break
        default:
            break
        }
    }
}
