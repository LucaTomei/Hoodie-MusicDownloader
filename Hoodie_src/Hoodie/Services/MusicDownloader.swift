//
//  MusicDownloader.swift
//  Hoodie
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation

class MusicDownloader{
    let download_url = "http://dz.loaderapp.info/deezer/\(128)/"
    
    
    
    func downloadTrack(url:String, trackName:String,completion: @escaping () -> ()) -> URL{
        if let audioUrl = URL(string: download_url + url) {

            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            // lets create your destination file url
            //let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent).appendingPathExtension("mp3")
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(trackName).appendingPathExtension("mp3")
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                completion()
                // if the file doesn't exist
            } else {

                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        MusicInLocal = fileManager.getSongsInDocument()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                        completion()
                    } catch {
                        print(error)
                    }
                }.resume()
            }
            return destinationUrl.absoluteURL
        }
        let url: URL = NSURL() as URL
        return url
    }
    
    
}
