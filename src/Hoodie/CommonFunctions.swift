//
//  CommonFunctions.swift
//  Hoodie
//
//  Created by Luca Tomei on 28/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation
import UIKit

let applicationTintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)

func dismissKeyboardOnTap(view:UIView){
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}

