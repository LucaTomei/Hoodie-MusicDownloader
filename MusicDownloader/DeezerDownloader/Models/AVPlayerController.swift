//
//  AVPlayerController.swift
//  DeezerDownloader
//
//  Created by Luca Tomei on 22/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation

import Foundation
import AVFoundation

//Share the player to avoid repeating playing AVPlayer when
// exiting the previous page and then entering the player

class AVPlayerController {
    static let shared = AVPlayerController()
    let player = AVPlayer()
}
