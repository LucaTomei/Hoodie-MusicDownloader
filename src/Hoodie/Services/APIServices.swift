//
//  APIServices.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import Foundation

class APIServices {
    
    func fetchPlaylist(id: Int, completion: @escaping (Playlist) -> ()){
        guard let url = URL(string: "https://api.deezer.com/playlist/\(id)") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let playlist = try decoder.decode(Playlist.self, from: data)
                completion(playlist)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    func fetchAlbum(id: Int, completion: @escaping (CompleteAlbumSearch) -> ()){
        guard let url = URL(string: "https://api.deezer.com/album/\(id)") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let album = try decoder.decode(CompleteAlbumSearch   .self, from: data)
                completion(album)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    func fetchArtist(id: Int, completion: @escaping (ArtistInfo) -> ()){
        guard let url = URL(string: "https://api.deezer.com/artist/\(id)") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let artist = try decoder.decode(ArtistInfo.self, from: data)
                completion(artist)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    func fetchGenres(completion: @escaping (GenreList) -> ()){
        guard let url = URL(string: "https://api.deezer.com/genre") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let genres = try decoder.decode(GenreList.self, from: data)
                completion(genres)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    
    func fetchSearch(query: String, completion: @escaping (SearchResponse) -> ()){
        let queryField = query.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        guard let url = URL(string: "https://api.deezer.com/search?q=\(queryField)") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SearchResponse.self, from: data)
                completion(response)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    func fetchAlbumSearch(query: String, completion: @escaping (SearchAlbumResponse) -> ()){
        let queryField = query.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        guard let url = URL(string: "https://api.deezer.com/search/album?q=\(queryField)") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SearchAlbumResponse.self, from: data)
                completion(response)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    func fetchPlaylistSearch(query: String, completion: @escaping (SearchPlaylistResponse) -> ()){
        let queryField = query.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        guard let url = URL(string: "https://api.deezer.com/search/playlist?q=\(queryField)") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SearchPlaylistResponse.self, from: data)
                completion(response)
            } catch {print(error.localizedDescription)}
            
        }.resume()
    }
}
