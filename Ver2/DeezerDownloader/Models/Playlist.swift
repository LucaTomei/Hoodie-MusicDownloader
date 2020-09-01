//
//  Playlist.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import Foundation


struct Playlist: Codable {
    var id: Int
    var title: String
    var picture: String
    var creator: Creator
    var tracks: Tracks
    
    enum CodingKeys: String, CodingKey {
        case id, title, creator, tracks
        case picture = "picture_medium"
        
    }
}

struct Creator: Codable {
    var id: Int
    var name: String
}

struct Tracks: Codable {
    var data: [Track]
}
