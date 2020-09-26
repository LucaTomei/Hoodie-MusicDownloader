//
//  SearchResponse.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//


import Foundation

struct SearchResponse: Codable {
    var data: [Track]
}

struct SearchAlbumResponse: Codable {
    var data: [AlbumSearchObject]
}

struct AlbumSearchObject: Codable {
    var id: Int
    var title: String
    var cover: String
    var artist: Artist
    
    enum CodingKeys: String, CodingKey {
        case id, title, artist
        case cover = "cover_medium"
    }
}
