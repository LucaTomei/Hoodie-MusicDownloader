//
//  MyFileManager.swift
//  DeezerDownloader
//
//  Created by Luca Tomei on 04/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MusicFile {
    var musicTitle:String? = ""
    var musicArtist:String? = ""
    var musicImage:UIImage? = nil
}

class MyFileManager {
    func getFilesInDocument() -> [URL]{
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {return [] }
    }
    
    func getSongsInDocument() ->[music]{
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            var songs:[music] = []
            for file in fileURLs{
                let mp3Details = getMP3Details(mp3_file: file)
                
                let thisSong = music(trackName: mp3Details.0, artistName: mp3Details.1)
                songs.append(thisSong)
            }
            return songs
        } catch {return [] }
    }
    
    
    
    func getMP3Details(mp3_file:URL) ->(String, String, UIImage) {
        var albumImage:UIImage = UIImage()
        var songTitle:String = ""
        var artist:String = ""
        
        var asset = AVAsset(url: mp3_file) as AVAsset
        for metaDataItems in asset.commonMetadata {
            if metaDataItems.commonKey!.rawValue == "artwork" {
                let imageData = metaDataItems.value as! NSData
                var image2: UIImage = UIImage(data: imageData as Data)!
                albumImage = image2
            }
            if metaDataItems.commonKey!.rawValue == "title" {
                songTitle = metaDataItems.value as! String
            }
            if metaDataItems.commonKey!.rawValue == "artist" {
                artist = metaDataItems.value as! String
            }
        }
        return (songTitle, artist, albumImage)
    }
    
    
    func clearDiskCache() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            var songs:[music] = []
            for file in fileURLs{
                try? fileManager.removeItem(atPath: file.path)
            }
        } catch {}
    }
    
    
}
