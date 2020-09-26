//
//  RegistrationViewController.swift
//  Hoodie
//
//  Created by Luca Tomei on 24/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import FirebaseAuth


class RegistrationViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var whatsYourEmailLabel: UILabel!
    @IBOutlet weak var joinNewsButton: UIButton!
    @IBOutlet weak var joinNewsLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
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
        var message:String = ""
        let signUpManager = AuthManager()
        guard let email = emailField.text, let password = passwordField.text else { return }
        if signUpManager.isValidPassword(password) && signUpManager.isValidEmail(email){
            signUpManager.signUp(email: email, password: password) { error in
                if let error = error as? NSError {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                      message = "Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section."
                    case .emailAlreadyInUse:
                        message = "Error: The email address is already in use by another account."
                    case .invalidEmail:
                        message = "Error: The email address is badly formatted."
                    case .weakPassword:
                        message = "Error: The password must be 6 characters long or more."
                    default:
                        message = "Error: \(error.localizedDescription)"
                    }
                    self.displayAlert(message: message)
                  } else {
                    message = "User signs up successfully"
                    self.goToMainView()
                  }
            }
        }else{
            self.displayAlert(message:"Error: Password or Email address is not valid. Check that your pass is 6 characters long")
        }
        
    }
    
    func displayAlert(message:String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func goToMainView(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showMain", sender: self)
        }
    }
}
