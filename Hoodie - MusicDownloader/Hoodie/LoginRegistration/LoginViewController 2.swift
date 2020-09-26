//
//  LoginViewController.swift
//  DeezerDownloader
//
//  Created by Luca Tomei on 24/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        signupButton.setTitleColor(UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1), for: .normal)
    }
    
    @IBAction func didPressLogin(_ sender: Any) {
    }
    
}
