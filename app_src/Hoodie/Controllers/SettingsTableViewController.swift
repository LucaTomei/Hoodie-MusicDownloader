//
//  SettingsTableViewController.swift
//  Hoodie
//
//  Created by Luca Tomei on 23/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import SafariServices
import SwiftMessages

import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    
    let ourEmailAddress:[String] = ["luca.tom1995@gmail.com", "trinca.1542534@studenti.uniroma1.it", "marzilli.1878501@studenti.uniroma1.it"]
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var daniloImageView: UIImageView!
    @IBOutlet weak var giovanniImageView: UIImageView!
    
    
    @IBOutlet weak var versionNumberLabel: UILabel!
    
    let myFileManager = MyFileManager()
    let myTwitterURLStr = "https://twitter.com/LucaTomei1995"
    let myWebPage = "https://lucatomei.github.io"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setAppVersion()
        tableView.tableFooterView = UIView()    // remove unused cell after logout

        // Set imageview Size
        myImageView.setRounded()
        daniloImageView.setRounded()
        giovanniImageView.setRounded()
        
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Settings"

        //For back button in navigation bar
        let button = UIBarButtonItem(title: "YourTitle", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(goBack))
        self.navigationItem.backBarButtonItem = button
    }
    
    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showWebPage(_ which: String) {
        if let url = URL(string: which) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return 2
            case 2: return 1
            case 3: return 2
            case 4:
                return 3    // for to show only my name return 1
            case 5: return 1
            default:    return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        print("Selected \(indexPath.section) - \(indexPath.row)")
        switch section {
        case 0:
            // This is the first section - About Session
            return
        case 1:
            // Informations Session
            if row == 0{
                showWebPage(myTwitterURLStr)
            }else{
                showWebPage(myWebPage)
            }
            return
        case 2:
            // Cache Session
            confirmDeleteCache()
            return
        case 3:
            // How To Help Session
            return
        case 4:
            // Credits Session
            return
        case 5:
            // Logout Session
            logoutUser()
            return
        default:
            return  // Do nothing
        }
    }
    
    
    
    
    func setAppVersion(){
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionNumberLabel.text = appVersion
    }
    
    
    func confirmDeleteCache() {
        displayAlertButton(viewController: self, title: "Clear Data Cache", body: "Do You Want to Erase all Data?",buttonTitle: "Delete 🎵") {
            beautifulSuccessAlert(viewController: self, title: "Data has been cleared", subtitle: nil, customImage: UIImage(named: "AppLogo")!)
            self.myFileManager.clearDiskCache()
            
        }
    }
    
    
    
    func logoutUser() {
        print("Logout Clicked")
        AuthManager().logout()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4{  // set size only for my section
            return 40.0
        }
        return UITableView.automaticDimension;//Choose your custom row height
    }
    
    
    @IBAction func didSendMailToMe(_ sender: Any) {
        sendEmail(to: ourEmailAddress[0])
    }
    
    @IBAction func didSendMailToDanilo(_ sender: Any) {
        sendEmail(to: ourEmailAddress[1])
    }
    
    @IBAction func didSendMailToGiovanni(_ sender: Any) {
        sendEmail(to: ourEmailAddress[2])
    }
    
    
    
    func sendEmail(to:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([to])
            mail.setMessageBody("<p>You're app is so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            beautifulSuccessAlert(viewController: self, title: "Unable to send email", subtitle: "Maybe you don't have mail app installed.", customImage: UIImage(named: "AppLogo")!)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}


extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.size.width ?? 0.0) / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 0.7
        self.layer.borderColor = applicationTintColor.cgColor
   }
}
