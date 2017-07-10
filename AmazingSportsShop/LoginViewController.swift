//
//  LoginViewController.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-07.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var joinNowButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.style = GIDSignInButtonStyle.wide
        authStateObserver()
    }
    
    func authStateObserver(){
        Firebase.Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func joinNowDidTouch(_ sender: Any) {
        
    }
    @IBAction func loginDidTouch(_ sender: Any) {
        
    }
    
}
