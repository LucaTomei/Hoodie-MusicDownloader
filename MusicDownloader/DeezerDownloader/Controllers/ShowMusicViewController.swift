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
//    var player = AVAudioPlayer()
//
//    var audioTimer = Timer()
//
//    var files_in_dir:[URL]!
//
//    let MusicDL = MusicDownloader()
//
    var selectedTrack:Track!
//
//    var isPlaying:Bool!
//    var curIdx:Int = 0          // indice corrente della canzone che sta suonando
    
    
//    @IBOutlet weak var progressbar: UISlider!
//    @IBOutlet weak var albumImage: UIImageView!
//    @IBOutlet weak var songTitlteLabel: UILabel!
//    @IBOutlet weak var artistLabel: UILabel!
//
//    @IBOutlet weak var justListenedMusicTime: UILabel!
//    @IBOutlet weak var remainingMusicTime: UILabel!
//    @IBOutlet weak var nextTrackBtn: UIButton!
//
//
//    @IBOutlet weak var playPauseBtn: UIButton!
//    @IBOutlet weak var prevTrackBtn: UIButton!
//
//    @IBOutlet weak var volumeSlider: UISlider!
//    @IBOutlet weak var randomBtn: UIButton!
//    @IBOutlet weak var repeatBtn: UIButton!
    
    
    @IBOutlet weak var ProgressSlider: UISlider!
    @IBOutlet weak var AlbumImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ArtistLabel: UILabel!
    
    @IBOutlet weak var TimePassed: UILabel!
    @IBOutlet weak var TimeRemained: UILabel!
    @IBOutlet weak var nextTrackBtn: UIButton!
    
    
    @IBOutlet weak var PlayButtonOutlet: UIButton!
    @IBOutlet weak var prevTrackBtn: UIButton!
    
    @IBOutlet weak var VolumeSlider: UISlider!
    @IBOutlet weak var RandomButton: UIButton!
    @IBOutlet weak var RepeatButton: UIButton!
    
    
    var CurrentIndex = Int(0)
    var isplaying = true
    var SongPlaying : music!
    
    var lengthOfSong : Float64?
    var Songs : [music]!
    var SongsDefault : [music]?
    var RepeatType = RepeatTypes.NotRepeat
    var RandomType = RandomTypes.NotRandom
    
    
    
    
    let player = AVPlayerController.shared.player
    var SongURL : URL{
        return SongPlaying.getFileURL()!
    }
    
    func setplayer(Song: music){
        let playeritem = AVPlayerItem(url: SongURL)
        player.replaceCurrentItem(with: playeritem)
        lengthOfSong = CMTimeGetSeconds(playeritem.asset.duration)
        ProgressSlider.minimumValue = 0
        ProgressSlider.maximumValue = Float( lengthOfSong!)
        NameLabel.text = Song.trackName
        ArtistLabel.text = Song.artistName
        
        // Insert image on player view
        DispatchQueue.main.async {
            self.AlbumImageView.image = fromSongUrlToImage(mp3_file: self.SongURL)
        }
    }
    
    @IBAction func playbutton(_ sender: UIButton) {
        
        if !isplaying {
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            addPeriodicObserver()
            isplaying = true
            player.play()

        }else {
            player.pause()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isplaying = false
        }
        
    }
                
    @IBAction func nexttrack(_ sender: Any) {
        let index = Songs.firstIndex(of: SongPlaying) ?? 0
        print (index)
        if index != Songs.count-1{
            SongPlaying = Songs[index+1]
            setplayer(Song: SongPlaying)
        }else{
            SongPlaying = Songs[0]
            setplayer(Song: SongPlaying)
        }
        player.play()
    }
    
    
    // previous track click
    @IBAction func lasttrack(_ sender: Any) {
        if player.currentTime().seconds > 5{
            let Time = CMTime(value: 0, timescale: 1)
            player.seek(to: Time)
        }else{
            let index = Songs.firstIndex(of: SongPlaying) ?? 0
            if index != 0{
                SongPlaying = Songs[index-1]
                setplayer(Song: SongPlaying)
            }else{
                SongPlaying = Songs[Songs.count-1]
                setplayer(Song: SongPlaying)
            }
            player.play()
            
        }
    }
    
    
    // next track click
    @IBAction func volumeControl(_ sender: UISlider) {
        sender.minimumValue = 0
        sender.maximumValue = 1
        player.volume = sender.value
        
    }
    
    @IBAction func progressControl(_ sender: UISlider) {
        let timeSeekTo = CMTime(seconds: Double(sender.value), preferredTimescale: 1)
        player.seek(to: timeSeekTo)
    }
    
    @IBAction func repeatPressed(_ sender: UIButton) {
        switch RepeatType{
        case .NotRepeat:
            RepeatType = .RepeatAll
            RepeatButton.backgroundColor = .systemBlue
            RepeatButton.tintColor = .white
        case .RepeatAll:
            RepeatType = .RepeatOne
            RepeatButton.setImage(UIImage(systemName: "repeat.1"), for: .normal)
        case .RepeatOne:
            RepeatType = .NotRepeat
            RepeatButton.setImage(UIImage(systemName: "repeat"), for: .normal)
            RepeatButton.backgroundColor = .white
            RepeatButton.tintColor = .systemBlue
        }
        
    }
    
    @IBAction func randomPressed(_ sender: UIButton) {
        switch RandomType {
        case .NotRandom:
            RandomType = .Random
            RandomButton.backgroundColor = .systemBlue
            RandomButton.tintColor = .white
            SongsDefault = Songs
            Songs.shuffle()
        case .Random:
            RandomType = .NotRandom
            RandomButton.backgroundColor = .white
            RandomButton.tintColor = .systemBlue
            Songs = SongsDefault
        }
    }
    
    
    func formatedTime(time: Float64) -> String{
        let time = Int(time)
        let min = Int (time / 60)
        let sec = Int (time % 60)
        return String(format: "%d:%02d", min, sec)
    }
    
    func addPeriodicObserver(){
        let timeInterval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { (CMTime) in
            let currentTime = CMTimeGetSeconds(self.player.currentTime())
            self.TimePassed.text = self.formatedTime(time: currentTime)
            self.TimeRemained.text = " -\( self.formatedTime(time: Double(self.ProgressSlider.maximumValue) - currentTime))"
            self.ProgressSlider.value = Float(currentTime)
        }
    }

    
    
    func getImage(url: URL, completionHandler: @escaping (UIImage?) -> ()) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let data = data, let image = UIImage(data: data){
                completionHandler(image)
            }else{
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
    
    func set_colors(){
        PlayButtonOutlet.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        RandomButton.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        RepeatButton.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        nextTrackBtn.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        prevTrackBtn.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        VolumeSlider.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    }
    
    
    override func viewDidLoad() {
        set_colors()
        setplayer(Song: SongPlaying)
        player.play()
        addPeriodicObserver()
        NameLabel.text = SongPlaying.trackName
        ArtistLabel.text = SongPlaying.artistName
        VolumeSlider.value = player.volume
        
    
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            switch self.RepeatType{
            case .NotRepeat:
                let index = self.Songs.firstIndex(of: self.SongPlaying)
                if index == self.Songs.count-1{
                    self.nexttrack(self)
                    self.player.pause()
                    self.PlayButtonOutlet.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    self.isplaying = false

                }else{
                    self.nexttrack(self)
                }
            case .RepeatOne:
                let Time = CMTime(value: 0, timescale: 1)
                self.player.seek(to: Time)
                self.player.play()
            case .RepeatAll:
                self.nexttrack(self)
            }
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        files_in_dir = getFilesInDir()
//
//
//        selectedTrack.album.cover.downloadImage { (img) in
//            DispatchQueue.main.async {
//                self.albumImage.image = img!
//            }
//        }
//        artistLabel.text = selectedTrack.artist.name
//        songTitlteLabel.text = selectedTrack.title
//
//
//        // Migliora il download della musica
//        // Prova: https://stackoverflow.com/questions/56194101/how-to-download-and-save-an-audio-file-and-then-play-it-in-swift
//
//        var downloaded_file_path = MusicDL.downloadTrack(url: self.selectedTrack.link) {
//
//        }
//
//        if files_in_dir.contains(downloaded_file_path){
//            curIdx = files_in_dir.firstIndex(of: downloaded_file_path)!
//        }else{
//            curIdx = 0
//        }
//
//
//        if downloaded_file_path != URL(string: ""){
//            try! player = AVAudioPlayer(contentsOf: downloaded_file_path)
//            player.play()
//            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
//        }
//
//        isPlaying = true
//        playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//    }
//
//
//
//
//
//    @IBAction func didPressPlay(_ sender: Any) {
//        if isPlaying{
//            playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
//            isPlaying = false
//            player.pause()
//        }else{
//            playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//            isPlaying = true
//            player.play()
//        }
//    }
//    @IBAction func didPressForward(_ sender: Any) {
//        var next_file = get_next_file(files_in_dir: files_in_dir)
//
//        try! player = AVAudioPlayer(contentsOf: next_file)
//        self.setMP3Details(mp3_file: next_file)
//        playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//        isPlaying = true
//        player.play()
//
//        //self.viewDidLoad()
//    }
//    @IBAction func didPressBackword(_ sender: Any) {
//        var prev_file = get_prev_file(files_in_dir: files_in_dir)
//        try! player = AVAudioPlayer(contentsOf: prev_file)
//        self.setMP3Details(mp3_file: prev_file)
//
//        playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//        isPlaying = true
//        player.play()
//        //self.viewDidLoad()
//    }
//
//
//    func getFilesInDir() -> [URL] {
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            return fileURLs
//            // process files
//        } catch {
//            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
//        }
//        var url: URL = NSURL() as URL
//        return [url]
//    }
//
//    func get_next_file(files_in_dir:[URL]) -> URL {
//        curIdx = curIdx.advanced(by: 1)
//        curIdx = curIdx > files_in_dir.endIndex ? files_in_dir.startIndex : curIdx
//        let isValidIndex = curIdx >= 0 && curIdx < files_in_dir.count
//        return isValidIndex ? files_in_dir[curIdx] : files_in_dir[0]
//        //return files_in_dir[curIdx]
//    }
//
//    func get_prev_file(files_in_dir:[URL]) -> URL {
//        curIdx = curIdx.advanced(by: -1)
//        curIdx = curIdx < files_in_dir.startIndex ? files_in_dir.endIndex : curIdx
//        let isValidIndex = curIdx >= 0 && curIdx < files_in_dir.count
//        return isValidIndex ? files_in_dir[curIdx] : files_in_dir[0]
//        //return files_in_dir[curIdx]
//
//    }
//
//
//    func setMP3Details(mp3_file:URL) {
//        var asset = AVAsset(url: mp3_file) as AVAsset
//        for metaDataItems in asset.commonMetadata {
//            if metaDataItems.commonKey!.rawValue == "artwork" {
//                let imageData = metaDataItems.value as! NSData
//                var image2: UIImage = UIImage(data: imageData as Data)!
//                albumImage.image = image2
//            }
//            if metaDataItems.commonKey!.rawValue == "title" {
//                songTitlteLabel.text = metaDataItems.value as! String
//            }
//            if metaDataItems.commonKey!.rawValue == "title" {
//                artistLabel.text = metaDataItems.value as! String
//            }
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
//        isPlaying = false
//        player.pause()
//    }
//
    
}
