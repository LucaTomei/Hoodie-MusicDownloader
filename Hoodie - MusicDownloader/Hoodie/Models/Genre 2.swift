//
//  Genre.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import Foundation

struct Genre: Codable {
    var id: Int
    var name: String
}

struct GenreList: Codable {
    var data: [Genre]
}
