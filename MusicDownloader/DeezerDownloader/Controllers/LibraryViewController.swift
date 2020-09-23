//
//  LibraryViewController.swift
//  DeezerDownloader
//
//  Created by Luca Tomei on 04/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var thisView: UICollectionView!
    let reuseIdentifier = "music_cell"
    var items:[MusicFile] = []
    var tracks:[Track] = []
    
    var musicTracks:[music] = []
    
    
    
    let myfilemanager_obj = MyFileManager()
    var files_in_document:[URL] = []
    
    var ContentShowed:[music] = []
    
    override func viewWillAppear(_ animated: Bool) {
        files_in_document = myfilemanager_obj.getFilesInDocument()
        for file in files_in_document{
            
            
            let (songTitle, artist, albumImage) = myfilemanager_obj.getMP3Details(mp3_file: file)
            
            let thisTrack = MusicFile()
            thisTrack.musicArtist = artist
            thisTrack.musicImage = albumImage
            thisTrack.musicTitle = songTitle
            items.append(thisTrack)
            
            let musicTrack = music(trackName: songTitle, artistName: artist)
            musicTracks.append(musicTrack)
        }
        ContentShowed = myfilemanager_obj.getSongsInDocument()
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! songCollectionViewCell
        
        let this_cell = self.items[indexPath.item]
        cell.trackName.text = this_cell.musicTitle
        
        if this_cell.musicImage != UIImage(){
            cell.icon.image = this_cell.musicImage
            //cell.trackIcon.removeFromSuperview()
            cell.trackIcon = nil
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let selectedTrack = musicTracks[indexPath.row]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showMusicFromLibrary", sender: selectedTrack)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMusicFromLibrary"{
            // preparo il dato
            let vc = segue.destination as! ShowMusicViewController // la casto alla classe di arrivo
            
            if let MusicPlayerVC = segue.destination as? ShowMusicViewController{
                let track = sender as! music
                let this_idx = fromTitleArtistToIdx(title: track.trackName!, artist: track.artistName!)
                
                MusicPlayerVC.SongPlaying = MusicInLocal[this_idx]
                MusicPlayerVC.Songs = MusicInLocal
            }
        }
    }
}

