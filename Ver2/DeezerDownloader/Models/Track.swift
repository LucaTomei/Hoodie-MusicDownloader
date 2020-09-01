//
//  Track.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import UIKit

struct Track: Codable {
    var id: Int
    var title: String
    var link:String
    var duration: Int
    var rank: Int
    var preview: String
    var artist: Artist
    var album: Album
}

struct Artist: Codable {
    var id: Int
    var name: String
}

struct Album: Codable {
    var id: Int
    var title: String
    var cover: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case cover = "cover_medium"
    }
}
