//
//  ArtistInfo.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import Foundation

struct ArtistInfo: Codable {
    var id: Int
    var name: String
    var img: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case img = "picture_medium"
    }
}
