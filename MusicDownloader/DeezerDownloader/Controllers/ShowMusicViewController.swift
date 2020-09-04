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
    
    var progress_view = UIProgressView()
    var audioTimer = Timer()
    
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
        
        
        selectedTrack.album.cover.downloadImage { (img) in
            DispatchQueue.main.async {
                self.albumImage.image = img!
            }
        }
        artistLabel.text = selectedTrack.artist.name
        songTitlteLabel.text = selectedTrack.title
        
        
        // Migliora il download della musica
        // Prova: https://stackoverflow.com/questions/56194101/how-to-download-and-save-an-audio-file-and-then-play-it-in-swift
        
        var downloaded_file_path = MusicDL.downloadTrack(url: self.selectedTrack.link)
        
        if files_in_dir.contains(downloaded_file_path){
            curIdx = files_in_dir.firstIndex(of: downloaded_file_path)!
        }else{
            curIdx = 0
        }
        
        
        if downloaded_file_path != URL(string: ""){
            try! player = AVAudioPlayer(contentsOf: downloaded_file_path)
            player.play()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progress_view.setProgress(Float(player.currentTime/player.duration), animated:false)
        }
        
        isPlaying = true
        playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    


    
    @objc func updateAudioProgressView()
    {
       if player.isPlaying
          {
           // Update progress
           progress_view.setProgress(Float(player.currentTime/player.duration), animated: true)
          }
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
        self.setMP3Details(mp3_file: next_file)
        playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isPlaying = true
        player.play()

        //self.viewDidLoad()
    }
    @IBAction func didPressBackword(_ sender: Any) {
        var prev_file = get_prev_file(files_in_dir: files_in_dir)
        try! player = AVAudioPlayer(contentsOf: prev_file)
        self.setMP3Details(mp3_file: prev_file)
        
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
        let isValidIndex = curIdx >= 0 && curIdx < files_in_dir.count
        return isValidIndex ? files_in_dir[curIdx] : files_in_dir[0]
        //return files_in_dir[curIdx]
    }
    
    func get_prev_file(files_in_dir:[URL]) -> URL {
        curIdx = curIdx.advanced(by: -1)
        curIdx = curIdx < files_in_dir.startIndex ? files_in_dir.endIndex : curIdx
        let isValidIndex = curIdx >= 0 && curIdx < files_in_dir.count
        return isValidIndex ? files_in_dir[curIdx] : files_in_dir[0]
        //return files_in_dir[curIdx]
        
    }
    
    
    func setMP3Details(mp3_file:URL) {
        var asset = AVAsset(url: mp3_file) as AVAsset
        for metaDataItems in asset.commonMetadata {
            if metaDataItems.commonKey!.rawValue == "artwork" {
                let imageData = metaDataItems.value as! NSData
                var image2: UIImage = UIImage(data: imageData as Data)!
                albumImage.image = image2
            }
            if metaDataItems.commonKey!.rawValue == "title" {
                songTitlteLabel.text = metaDataItems.value as! String
            }
            if metaDataItems.commonKey!.rawValue == "title" {
                artistLabel.text = metaDataItems.value as! String
            }
        }
    }
    
    
    
}
