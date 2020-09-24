//
//  RegistrationViewController.swift
//  DeezerDownloader
//
//  Created by Luca Tomei on 24/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var whatsYourEmailLabel: UILabel!
    @IBOutlet weak var joinNewsButton: UIButton!
    @IBOutlet weak var joinNewsLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        joinNewsLabel.isHidden = true
        joinNewsButton.isHidden = true
        whatsYourEmailLabel.textColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        signupButton.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    }
    

    @IBAction func didPressDismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressSignup(_ sender: Any) {
    }
    
}
