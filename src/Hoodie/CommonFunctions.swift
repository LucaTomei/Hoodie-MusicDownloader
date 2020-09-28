//
//  CommonFunctions.swift
//  Hoodie
//
//  Created by Luca Tomei on 28/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation
import UIKit

func dismissKeyboardOnTap(view:UIView){
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}
