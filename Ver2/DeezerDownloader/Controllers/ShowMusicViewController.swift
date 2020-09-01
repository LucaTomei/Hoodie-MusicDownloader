//
//  ShowMusicViewController.swift
//  DeezerDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import AVFoundation

class ShowMusicViewController: UIViewController {
    var player = AVAudioPlayer()
    
    var files_in_dir:[URL]!
    
    let MusicDL = MusicDownloader()
    
    var selectedTrack:Track!
    
    var isPlaying:Bool!
    var curIdx:Int = 0          // indice corrente della canzone che sta suonando
    
    @IBOutlet weak var progressview: UIProgressView!
    @IBOutlet weak var albumImage: UIImageView!
    
    @IBOutlet weak var songTitlteLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var remainingMusicTime: UILabel!
    @IBOutlet weak var justListenedMusicTime: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    var audioPlayer : AVPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        files_in_dir = getFilesInDir()
        curIdx = files_in_dir.startIndex
        
        selectedTrack.album.cover.downloadImage { (img) in
            DispatchQueue.main.async {
                self.albumImage.image = img!
            }
        }
        artistLabel.text = selectedTrack.artist.name
        songTitlteLabel.text = selectedTrack.title
        
        var downloaded_file_path = MusicDL.downloadTrack(url: self.selectedTrack.link)
        
        if downloaded_file_path != URL(string: ""){
            try! player = AVAudioPlayer(contentsOf: downloaded_file_path)
            player.play()
            
        }
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        isPlaying = true
        playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        
    }
        
    
    

    

    @IBAction func didPressPlay(_ sender: Any) {
        if isPlaying{
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlaying = false
            player.pause()
        }else{
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            isPlaying = true
            player.play()
        }
    }
    @IBAction func didPressForward(_ sender: Any) {
        var next_file = get_next_file(files_in_dir: files_in_dir)
        
        try! player = AVAudioPlayer(contentsOf: next_file)
        self.setMP3Image(mp3_file: next_file)
        playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isPlaying = true
        player.play()

        //self.viewDidLoad()
    }
    @IBAction func didPressBackword(_ sender: Any) {
        var prev_file = get_prev_file(files_in_dir: files_in_dir)
        try! player = AVAudioPlayer(contentsOf: prev_file)
        self.setMP3Image(mp3_file: prev_file)
        
        playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isPlaying = true
        player.play()
        //self.viewDidLoad()
    }
    
    
    func getFilesInDir() -> [URL] {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return fileURLs
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        var url: URL = NSURL() as URL
        return [url]
    }
    
    func get_next_file(files_in_dir:[URL]) -> URL {
        curIdx = curIdx.advanced(by: 1)
        curIdx = curIdx > files_in_dir.endIndex ? files_in_dir.startIndex : curIdx
        return files_in_dir[curIdx]
    }
    
    func get_prev_file(files_in_dir:[URL]) -> URL {
        curIdx = curIdx.advanced(by: -1)
        curIdx = curIdx < files_in_dir.startIndex ? files_in_dir.endIndex : curIdx
        return files_in_dir[curIdx]
    }
    
    
    func setMP3Image(mp3_file:URL) {
        var asset = AVAsset(url: mp3_file) as AVAsset
        for metaDataItems in asset.commonMetadata {
            if metaDataItems.commonKey!.rawValue == "artwork" {
                let imageData = metaDataItems.value as! NSData
                var image2: UIImage = UIImage(data: imageData as Data)!
                albumImage.image = image2
            }
        }
        
    }
}
