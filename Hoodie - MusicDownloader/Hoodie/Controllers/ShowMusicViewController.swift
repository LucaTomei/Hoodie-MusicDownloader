//
//  ShowMusicViewController.swift
//  Hoodie
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import AVFoundation



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
//        player.play()
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
    
}
