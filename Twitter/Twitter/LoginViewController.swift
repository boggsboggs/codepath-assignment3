//
//  LoginViewController.swift
//  Twitter
//
//  Created by John Boggs on 2/21/15.
//  Copyright (c) 2015 Codepath. All rights reserved.
//

import UIKit

let LOGGED_IN_KEY = "LoggedIn?"

class LoginViewController: UIViewController {
    var delegate : LoginViewControllerDelegate?
    let defaults = NSUserDefaults.standardUserDefaults()

    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        NSLog("Login Button Pressed")
        TwitterClient.instance.loginCallback = { (user: User?, error : NSError?) in
            if let error = error {
                println("error: \(error)")
            }
            if let user = user {
                NSLog("Success")
                self.defaults.setBool(true, forKey: LOGGED_IN_KEY)
                self.delegate?.dismissModal()
            }
        }
        TwitterClient.instance.oauthLogin()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

protocol LoginViewControllerDelegate {
    func dismissModal()
}