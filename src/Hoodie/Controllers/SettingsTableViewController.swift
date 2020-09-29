//
//  SettingsTableViewController.swift
//  Hoodie
//
//  Created by Luca Tomei on 23/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import SafariServices


class SettingsTableViewController: UITableViewController {
    
    
    // TODO
    /*
     - Add images on credits section
        - add mail icon
        - add telegram icon
     */
    
    @IBOutlet weak var versionNumberLabel: UILabel!
    
    let myFileManager = MyFileManager()
    let myTwitterURLStr = "https://twitter.com/LucaTomei1995"
    let myWebPage = "https://lucatomei.github.io"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppVersion()
        tableView.tableFooterView = UIView()    // remove unused cell after logout
        
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
            case 4: return 3    // for to show only my name return 1
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
        let alert = UIAlertController(title: "Erase all Data", message: "Do You Want to Erase all Data?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let alert = UIAlertController(title: "Updating data", message: "Please wait...", preferredStyle: .alert)

            alert.view.tintColor = UIColor.black
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            
            
            self.present(alert, animated: true) {
                self.dismiss(animated: true, completion: {
                let alert2 = UIAlertController(title: "Alert", message: "Data has been cleared", preferredStyle: UIAlertController.Style.alert)
                    alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert2, animated: true, completion: nil)
                })
            }
            self.myFileManager.clearDiskCache()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            return
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func logoutUser() {
        print("Logout Clicked")
        AuthManager().logout()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
}

