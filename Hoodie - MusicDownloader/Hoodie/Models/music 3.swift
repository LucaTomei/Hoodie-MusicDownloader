//
//  music.swift
//  Hoodie
//
//  Created by Luca Tomei on 22/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation
import UIKit

struct music : Equatable, Codable{
    var trackName : String?
    var artistName : String?
    
    func getFileURL() -> URL? {   //url of local music
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for file in fileURLs{
                if file.lastPathComponent == trackName! + ".mp3"{
                    return file.absoluteURL
                }
            }
        } catch {return documentsURL }
        return documentsURL
    }
    
    
    var artworkUrl100 : String?   // I use this value to determine if the image comes from the URL or the local machine
    
    
}

var fileManager = MyFileManager()
var MusicInLocal : [music] = fileManager.getSongsInDocument()


func fromTitleArtistToIdx(title:String, artist:String) -> Int{
    var i = 0
    for song in MusicInLocal{
        if song.trackName == title{
            return i
        }
        i = i+1
    }
    return -1
}

func fromSongUrlToImage(mp3_file:URL) -> UIImage{
    let fileManager = MyFileManager()
    return fileManager.getMP3Details(mp3_file: mp3_file).2
}

enum RepeatTypes {
    case NotRepeat
    case RepeatAll
    case RepeatOne
}

enum RandomTypes{
    case NotRandom
    case Random
}

