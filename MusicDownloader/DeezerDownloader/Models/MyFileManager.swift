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
            if metaDataItems.commonKey!.rawValue == "title" {
                artist = metaDataItems.value as! String
            }
        }
        return (songTitle, artist, albumImage)
    }
    
    
    
}