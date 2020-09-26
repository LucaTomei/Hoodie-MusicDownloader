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


class ShowMusicViewController: UIViewController, AVAudioPlayerDelegate {

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
    
    
    
    
    var player = AVAudioPlayer()
    var SongURL : URL{
        return SongPlaying.getFileURL()!
    }
    
    func setplayer(Song: music){
        let playeritem = AVPlayerItem(url: SongURL)
        do {
            player = try AVAudioPlayer(contentsOf: SongURL)
            player.delegate = self
            player.prepareToPlay()
        } catch let error as NSError {
            print("Failed to init audio player: \(error)")
        }
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
            //addPeriodicObserver()
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
        updateNowPlaying(isPause: false)
        setupNowPlaying()
    }
    
    
    // previous track click
    @IBAction func lasttrack(_ sender: Any) {
//        if player.currentTime().seconds > 5{
//            let Time = CMTime(value: 0, timescale: 1)
//            player.seek(to: Time)
//        }else{
//            let index = Songs.firstIndex(of: SongPlaying) ?? 0
//            if index != 0{
//                SongPlaying = Songs[index-1]
//                setplayer(Song: SongPlaying)
//            }else{
//                SongPlaying = Songs[Songs.count-1]
//                setplayer(Song: SongPlaying)
//            }
//            player.play()
//
//        }
    }
    
    
    // next track click
    @IBAction func volumeControl(_ sender: UISlider) {
        sender.minimumValue = 0
        sender.maximumValue = 1
        player.volume = sender.value
    }
    
    @IBAction func progressControl(_ sender: UISlider) {
//        let timeSeekTo = CMTime(seconds: Double(sender.value), preferredTimescale: 1)
//        player.seek(to: timeSeekTo)
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
    
    
//    override func viewDidLoad() {
//        set_colors()
//        setplayer(Song: SongPlaying)
//        player.play()
//        //addPeriodicObserver()
//        NameLabel.text = SongPlaying.trackName
//        ArtistLabel.text = SongPlaying.artistName
//        VolumeSlider.value = player.volume
//
//
////        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
////            switch self.RepeatType{
////            case .NotRepeat:
////                let index = self.Songs.firstIndex(of: self.SongPlaying)
////                if index == self.Songs.count-1{
////                    self.nexttrack(self)
////                    self.player.pause()
////                    self.PlayButtonOutlet.setImage(UIImage(systemName: "play.fill"), for: .normal)
////                    self.isplaying = false
////
////                }else{
////                    self.nexttrack(self)
////                }
////            case .RepeatOne:
////                let Time = CMTime(value: 0, timescale: 1)
////                self.player.seek(to: Time)
////                self.player.play()
////            case .RepeatAll:
////                self.nexttrack(self)
////            }
////        }
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_colors()
        setplayer(Song: SongPlaying)
        setupRemoteTransportControls()
        setupNowPlaying()
        setupNotifications()
        play()
        setupMediaPlayerNotificationView()
    }
    
    
    
    
}


extension ShowMusicViewController{
    
    func setupRemoteTransportControls() {
      // Get the shared MPRemoteCommandCenter
      let commandCenter = MPRemoteCommandCenter.shared()
      
      // Add handler for Play Command
      commandCenter.playCommand.addTarget { [unowned self] event in
        print("Play command - is playing: \(self.player.isPlaying)")
        if !self.player.isPlaying {
          self.play()
            self.isplaying = true
          return .success
        }
        return .commandFailed
      }
      
      // Add handler for Pause Command
      commandCenter.pauseCommand.addTarget { [unowned self] event in
        print("Pause command - is playing: \(self.player.isPlaying)")
        if self.player.isPlaying {
          self.pause()
            self.isplaying = false
            
          return .success
        }
        return .commandFailed
      }
    }
    
    
    func setupNowPlaying() {
      // Define Now Playing Info
      var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = SongPlaying.trackName
      
        
        if let image = fromSongUrlToImage(mp3_file: SongPlaying.getFileURL()!) as? UIImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
              return image
            }
        }
      
      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
      nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.duration
      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
      
      // Set the metadata
      MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func updateNowPlaying(isPause: Bool) {
      // Define Now Playing Info
      var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!
      
      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1
      
      // Set the metadata
      MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupNotifications() {
      let notificationCenter = NotificationCenter.default
      notificationCenter.addObserver(self,
                                     selector: #selector(handleInterruption),
                                     name: AVAudioSession.interruptionNotification,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(handleRouteChange),
                                     name: AVAudioSession.routeChangeNotification,
                                     object: nil)
    }
    
    // MARK: Handle Notifications
    @objc func handleRouteChange(notification: Notification) {
      guard let userInfo = notification.userInfo,
        let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
        let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
          return
      }
      switch reason {
      case .newDeviceAvailable:
        let session = AVAudioSession.sharedInstance()
        for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.headphones {
          print("headphones connected")
          DispatchQueue.main.sync {
            self.play()
          }
          break
        }
      case .oldDeviceUnavailable:
        if let previousRoute =
          userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
          for output in previousRoute.outputs where output.portType == AVAudioSession.Port.headphones {
            print("headphones disconnected")
            DispatchQueue.main.sync {
              self.pause()
            }
            break
          }
        }
      default: ()
      }
    }
    
    @objc func handleInterruption(notification: Notification) {
      guard let userInfo = notification.userInfo,
        let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
          return
      }
      
      if type == .began {
        print("Interruption began")
        // Interruption began, take appropriate actions
      }
      else if type == .ended {
        if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
          let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
          if options.contains(.shouldResume) {
            // Interruption Ended - playback should resume
            print("Interruption Ended - playback should resume")
            play()
          } else {
            // Interruption Ended - playback should NOT resume
            print("Interruption Ended - playback should NOT resume")
          }
        }
      }
    }
    
    // MARK: Actions
    @IBAction func togglePlayPause(_ sender: Any) {
      if (player.isPlaying) {
        pause()
      }
      else {
        play()
      }
    }
    
    func play() {
        player.play()
        PlayButtonOutlet.setTitle("Pause", for: UIControl.State.normal)
        updateNowPlaying(isPause: false)
        print("Play - current time: \(player.currentTime) - is playing: \(player.isPlaying)")
    }
    
    func pause() {
        player.pause()
        PlayButtonOutlet.setTitle("Play", for: UIControl.State.normal)
        updateNowPlaying(isPause: true)
        
        print("Pause - current time: \(player.currentTime) - is playing: \(player.isPlaying)")
    }
    
    @IBAction func stop(_ sender: Any) {
        player.stop()
        player.currentTime = 0
        PlayButtonOutlet.setTitle("Play", for: UIControl.State.normal)
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing: \(flag)")
        if (flag) {
            updateNowPlaying(isPause: true)
            PlayButtonOutlet.setTitle("Play", for: UIControl.State.normal)
        }
    }
    
    func setupMediaPlayerNotificationView(){
        let commandcenter = MPRemoteCommandCenter.shared()
        commandcenter.playCommand.addTarget{[unowned self] event in
            self.play()
            return .success
        }
        
        commandcenter.pauseCommand.addTarget{[unowned self] event in
            self.pause()
            return .success
        }
        
        
        
        commandcenter.nextTrackCommand.addTarget{[unowned self] event in
            #selector(self.nexttrack)
            return .success
        }
        
    }
}
