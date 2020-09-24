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
    
    var ContentShowed:[music] = []
    var myfilemanager_obj = MyFileManager()
    
    override func viewWillAppear(_ animated: Bool) {
        ContentShowed = myfilemanager_obj.getSongsInDocument()
        self.thisView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        ContentShowed = myfilemanager_obj.getSongsInDocument()
        self.thisView.reloadData()
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ContentShowed.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! songCollectionViewCell
        
        let this_cell = self.ContentShowed[indexPath.item]
        cell.trackName.text = this_cell.trackName
        
        
       
        if this_cell.getFileURL() != nil  {
            let albumImage = fromSongUrlToImage(mp3_file: this_cell.getFileURL()!)
            
            cell.icon.image = albumImage
            cell.trackIcon = nil
        }
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let selectedTrack = ContentShowed[indexPath.row]
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

