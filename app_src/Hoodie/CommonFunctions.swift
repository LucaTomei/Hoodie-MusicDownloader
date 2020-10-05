//
//  CommonFunctions.swift
//  Hoodie
//
//  Created by Luca Tomei on 28/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation
import UIKit

import SwiftMessages
import FCAlertView

let applicationTintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)

func dismissKeyboardOnTap(view:UIView){
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}


func downloadAlert(view:UIViewController ,title:String, message:String, progress:Float) {
    let alertController = UIAlertController(title: "Title", message: "Loading...", preferredStyle: .alert)

    let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)

       progressDownload.setProgress(progress/10.0, animated: true)
       progressDownload.frame = CGRect(x: 10, y: 70, width: 250, height: 0)

    alertController.view.addSubview(progressDownload)
    view.present(alertController, animated: true, completion: nil)
    alertController.dismiss(animated: true)
}


    
func showDownloadInProgressAlert(){
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureDropShadow()

    let applicationIcon = UIImage(named: "AppIcon")
    
    view.configureContent(title: "Download in Progress", body: "You can play all song once download has finished", iconImage: applicationIcon, iconText: .none, buttonImage: .none, buttonTitle: .none, buttonTapHandler: .none)
    view.iconImageView?.frame.size = CGSize(width: 50, height: 50)
    view.backgroundView.backgroundColor = applicationTintColor
    (view.backgroundView as? CornerRoundingView)?.cornerRadius = 5
    // Show the message.
    SwiftMessages.show(view: view)
}

func beautifulSuccessAlert(viewController:UIViewController, title:String, subtitle:String?, customImage:UIImage){
    let alert = FCAlertView()
    alert.colorScheme = applicationTintColor
    
    
    alert.showAlert(inView: viewController,
                    withTitle: title,
                    withSubtitle: subtitle,
                    withCustomImage: customImage,
                    withDoneButtonTitle: nil,
                    andButtons: nil)
}



func displayAlertButton(viewController:UIViewController, title:String, body:String, buttonTitle:String, action: @escaping () -> ()){
    
    var config = SwiftMessages.defaultConfig
    config.duration = .forever
    
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureTheme(.warning)
    
    // Add a drop shadow.
    view.configureDropShadow()

    let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
    view.configureContent(title: title, body: body, iconText: iconText)
    view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    view.button?.setTitle(buttonTitle, for: .normal)
    
    (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
    SwiftMessages.show(config: config, view: view)
    view.buttonTapHandler = { _ in
        SwiftMessages.hide()
        action()
    }
    
}


func getTodayDateDay() -> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd_MM_yyyy"
    let result = formatter.string(from: date)
    return result
}

func getTodayDateHourMinute() -> String{
    let dateFormatter : DateFormatter = DateFormatter()
    //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.dateFormat = "HH_mm"
    let date = Date()
    let dateString = dateFormatter.string(from: date)
    return dateString
}
