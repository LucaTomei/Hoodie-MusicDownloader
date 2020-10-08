//
//  FirebaseAuthManager.swift
//  Hoodie
//
//  Created by Luca Tomei on 24/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

import GoogleSignIn

import FBSDKCoreKit
import FBSDKLoginKit

class AuthManager {
    
    func getCurrentUserID() -> String{
        if let uid = Auth.auth().currentUser?.uid{
            return String(uid)
        }
        if let uid = GIDSignIn.sharedInstance()?.currentUser?.userID{
            return String(uid)
        }
        if let uid = AccessToken.current?.userID{
            return String(uid)
        }
        return "uid"
    }
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    func signUp(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let minPasswordLength = 6
        return password.count >= minPasswordLength
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance()?.signOut()
            try LoginManager().logOut()
        }
        catch { print("already logged out") }
    }
    
    
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error )
        }
    }
    
    
    
    
    
}
