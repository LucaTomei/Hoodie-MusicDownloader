//
//  LoginViewController.swift
//  Hoodie
//
//  Created by Luca Tomei on 24/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap(view: self.view)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        loginButton.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        signupButton.setTitleColor(UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1), for: .normal)
        
        print("Utente loggato: ",AuthManager().isUserLoggedIn())
        if AuthManager().isUserLoggedIn(){
            goToMainView(message: "")
        }
    }
    
    // When ENTER (Invio) is pressed close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }
    
    
    @IBAction func didPressLogin(_ sender: Any) {
        var message = ""
        guard let email = emailField.text, let password = passwordField.text else { return }
        AuthManager().signIn(email: email, password: password) { error in
            if let error = error as? NSError{
                //errore
                print(error.code)
                switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                      message = "Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console."
                        self.displayAlert(message: message)
                    case .userDisabled:
                        message = "Error: The user account has been disabled by an administrator."
                        self.displayAlert(message: message)
                    case .wrongPassword:
                        message = "Error: The password is invalid or the user does not have a password."
                        self.okCancelAlert(title: "Reset Password", message:"\(message) Do you want to reset your password?") {
                            AuthManager().sendPasswordReset(withEmail: email) { (error) in
                                if let error = error as? NSError {
                                  switch AuthErrorCode(rawValue: error.code) {
                                  case .userNotFound:
                                    message = "Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section."
                                  case .invalidEmail:
                                      message = "Error: The email address is badly formatted."
                                  case .invalidRecipientEmail:
                                      message = "Error: Indicates an invalid recipient email was sent in the request."
                                  case .invalidSender:
                                      message = "Error: Indicates an invalid sender email is set in the console for this action."
                                  case .invalidMessagePayload:
                                      message = "Error: Indicates an invalid email template for sending update email."
                                  default:
                                      message = "Error message: \(error.localizedDescription)"
                                  }
                                } else {
                                  message = "Reset password email has been successfully sent, check your email."
                                }
                                self.displayAlert(message: message)
                            }
                            
                        }
                    case .invalidEmail:
                        message = "Error: Indicates the email address is malformed."
                        self.displayAlert(message: message)
                    default:
                        message = "Error: \(error.localizedDescription)"
                        self.displayAlert(message: message)
                    }
            } else {
                message = "Login Completed"
                self.goToMainView(message: message)
            }
        }
    }
    
    func displayAlert(message:String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func goToMainView(message:String){
        //MyFileManager().clearDiskCache()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showMain", sender: self)
        }
    }
    
    func okCancelAlert(title:String, message:String, completionHandler: @escaping () -> Void){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
            completionHandler()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
             //print("Handle Cancel Logic here")
        }))

        self.present(refreshAlert, animated: true, completion: nil)
    }
    
}
