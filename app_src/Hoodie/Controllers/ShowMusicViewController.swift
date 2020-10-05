//
//  ShowMusicViewController.swift
//  Hoodie
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer



class ShowMusicViewController: UIViewController {

    var selectedTrack:Track!

    
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
    
    var launchedFromLibrary = false
    
    
    
    
    let player = AVPlayerController.shared.player
    
    var SongURL : URL{
        return SongPlaying.getFileURL()!
    }
    
    var playeritem:AVPlayerItem!
    
    func setplayer(Song: music, replace:Bool){
        playeritem = AVPlayerItem(url: Song.getFileURL()!)
        if SongPlaying != nil{
            print("Sto settando in locale")
            AVPlayerController.shared.SongPlaying = SongPlaying
            SongPlaying = AVPlayerController.shared.SongPlaying
        }
        if replace != false{
            player.replaceCurrentItem(with: playeritem)
        }
        lengthOfSong = CMTimeGetSeconds(playeritem.asset.duration)
        ProgressSlider.minimumValue = 0
        ProgressSlider.maximumValue = Float( lengthOfSong!)
        NameLabel.text = Song.trackName
        ArtistLabel.text = Song.artistName
        
        // Insert image on player view
        DispatchQueue.main.async {
            self.AlbumImageView.image = fromSongUrlToImage(mp3_file: Song.getFileURL()!)
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
        Songs = MyFileManager().getSongsInDocument()
        let index = self.Songs.firstIndex(of: AVPlayerController.shared.SongPlaying) ?? 0
        print("nexttrack:\nindex:\(index)\nAVPlayerController.shared.SongPlaying: \(AVPlayerController.shared.SongPlaying)\nSongPlaying: \(SongPlaying)\nSongs: \(Songs)")
        if index != Songs.count-1{
            AVPlayerController.shared.SongPlaying = self.Songs[index+1]
            setplayer(Song: AVPlayerController.shared.SongPlaying, replace: true)
        }else{
            AVPlayerController.shared.SongPlaying = self.Songs[0]
            setplayer(Song: AVPlayerController.shared.SongPlaying, replace: true)
        }
        print("Imposto la prossima canzone: \(AVPlayerController.shared.SongPlaying.trackName)")
        player.play()
    }
    
    
    // previous track click
    @IBAction func lasttrack(_ sender: Any) {
        if player.currentTime().seconds > 5{
            let Time = CMTime(value: 0, timescale: 1)
            player.seek(to: Time)
        }else{
            let index = Songs.firstIndex(of: AVPlayerController.shared.SongPlaying) ?? 0
            if index != 0{
                AVPlayerController.shared.SongPlaying = Songs[index-1]
                setplayer(Song: AVPlayerController.shared.SongPlaying, replace: true)
            }else{
                AVPlayerController.shared.SongPlaying = Songs[Songs.count-1]
                setplayer(Song: AVPlayerController.shared.SongPlaying, replace: true)
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
            RepeatButton.backgroundColor = applicationTintColor
            RepeatButton.tintColor = .white
        case .RepeatAll:
            RepeatType = .RepeatOne
            RepeatButton.setImage(UIImage(systemName: "repeat.1"), for: .normal)
        case .RepeatOne:
            RepeatType = .NotRepeat
            RepeatButton.setImage(UIImage(systemName: "repeat"), for: .normal)
            RepeatButton.backgroundColor = .white
            RepeatButton.tintColor = applicationTintColor
        }
        
    }
    
    @IBAction func randomPressed(_ sender: UIButton) {
        switch RandomType {
        case .NotRandom:
            RandomType = .Random
            RandomButton.backgroundColor = applicationTintColor
            RandomButton.tintColor = .white
            SongsDefault = Songs
            Songs.shuffle()
        case .Random:
            RandomType = .NotRandom
            RandomButton.backgroundColor = .white
            RandomButton.tintColor = applicationTintColor
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
            let currentTime = CMTimeGetSeconds(AVPlayerController.shared.player.currentTime())
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
        PlayButtonOutlet.tintColor = applicationTintColor
        RandomButton.tintColor = applicationTintColor
        RepeatButton.tintColor = applicationTintColor
        nextTrackBtn.tintColor = applicationTintColor
        prevTrackBtn.tintColor = applicationTintColor
        VolumeSlider.tintColor = applicationTintColor
        
        ProgressSlider.setThumbImage(UIImage(), for: .normal)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        print(self.tabBarController?.selectedIndex)
        
        let thisSong = AVPlayerController.shared.SongPlaying
        self.Songs = MyFileManager().getSongsInDocument()
        if thisSong.trackName != nil{
            setplayer(Song: thisSong, replace: false)
            addPeriodicObserver()
            
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
                switch self.RepeatType{
                case .NotRepeat:
                    let index = self.Songs.firstIndex(of: AVPlayerController.shared.SongPlaying)
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
        
    }
    
    
    
    override func viewDidLoad() {
        set_colors()
        self.Songs = MyFileManager().getSongsInDocument()
        
        if SongPlaying != nil{
            setplayer(Song: SongPlaying, replace: true)
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
            self.setupNowPlaying()
            self.setupRemoteTransportControls()
            // Set playing as first state
            MPNowPlayingInfoCenter.default().playbackState = .playing
        }
        if launchedFromLibrary{
            
            // Dismiss this view after 2 seconds
            DispatchQueue.main.async{
                self.dismiss(animated: true, completion: nil)
                self.view.isHidden = true
                self.PlayButtonOutlet.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.PlayButtonOutlet.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.player.play()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.PlayButtonOutlet.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.player.pause()
                return .success
            }
            return .commandFailed
        }

        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            guard let _self = self else { return .commandFailed }
            self?.lasttrack(self)

            return .success
        }

        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            guard let _self = self else { return .commandFailed }
            self?.nexttrack(self)

            return .success
        }
        
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = SongPlaying.trackName
        nowPlayingInfo[MPMediaItemPropertyArtist] = SongPlaying.artistName
        
        if let image = fromSongUrlToImage(mp3_file: SongPlaying.getFileURL()!) as? UIImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playeritem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playeritem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

}
