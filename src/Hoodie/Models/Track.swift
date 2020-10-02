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






// Complete album search Struct
struct CompleteAlbumSearch: Codable {
  struct Genres: Codable {
    struct Data: Codable {
      let id: Int
      let name: String
      let picture: URL
      let type: String
    }

    let data: [Data]
  }

  struct Contributors: Codable {
    let id: Int
    let name: String
    let link: URL
    let share: URL
    let picture: URL
    let pictureSmall: URL
    let pictureMedium: URL
    let pictureBig: URL
    let pictureXl: URL
    let radio: Bool
    let tracklist: URL
    let type: String
    let role: String

    private enum CodingKeys: String, CodingKey {
      case id
      case name
      case link
      case share
      case picture
      case pictureSmall = "picture_small"
      case pictureMedium = "picture_medium"
      case pictureBig = "picture_big"
      case pictureXl = "picture_xl"
      case radio
      case tracklist
      case type
      case role
    }
  }

  struct Artist: Codable {
    let id: Int
    let name: String
    let picture: URL
    let pictureSmall: URL
    let pictureMedium: URL
    let pictureBig: URL
    let pictureXl: URL
    let tracklist: URL
    let type: String

    private enum CodingKeys: String, CodingKey {
      case id
      case name
      case picture
      case pictureSmall = "picture_small"
      case pictureMedium = "picture_medium"
      case pictureBig = "picture_big"
      case pictureXl = "picture_xl"
      case tracklist
      case type
    }
  }

  struct Tracks: Codable {
    struct Data: Codable {
      struct Artist: Codable {
        let id: Int
        let name: String
        let tracklist: URL
        let type: String
      }

      let id: Int
      let readable: Bool
      let title: String
      let titleShort: String
      let titleVersion: String
      let link: URL
      let duration: Int
      let rank: Int
      let explicitLyrics: Bool
      let explicitContentLyrics: Int
      let explicitContentCover: Int
      let preview: URL
      let md5Image: String
      let artist: Artist
      let type: String

      private enum CodingKeys: String, CodingKey {
        case id
        case readable
        case title
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case link
        case duration
        case rank
        case explicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
        case preview
        case md5Image = "md5_image"
        case artist
        case type
      }
    }

    let data: [Data]
  }

  let id: Int
  let title: String
  let upc: String
  let link: URL
  let share: URL
  let cover: URL
  let coverSmall: URL
  let coverMedium: URL
  let coverBig: URL
  let coverXl: URL
  let md5Image: String
  let genreID: Int
  let genres: Genres
  let label: String
  let nbTracks: Int
  let duration: Int
  let fans: Int
  let rating: Int
  let releaseDate: String
  let recordType: String
  let available: Bool
  let tracklist: URL
  let explicitLyrics: Bool
  let explicitContentLyrics: Int
  let explicitContentCover: Int
  let contributors: [Contributors]
  let artist: Artist
  let type: String
  let tracks: Tracks

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case upc
    case link
    case share
    case cover
    case coverSmall = "cover_small"
    case coverMedium = "cover_medium"
    case coverBig = "cover_big"
    case coverXl = "cover_xl"
    case md5Image = "md5_image"
    case genreID = "genre_id"
    case genres
    case label
    case nbTracks = "nb_tracks"
    case duration
    case fans
    case rating
    case releaseDate = "release_date"
    case recordType = "record_type"
    case available
    case tracklist
    case explicitLyrics = "explicit_lyrics"
    case explicitContentLyrics = "explicit_content_lyrics"
    case explicitContentCover = "explicit_content_cover"
    case contributors
    case artist
    case type
    case tracks
  }
}
