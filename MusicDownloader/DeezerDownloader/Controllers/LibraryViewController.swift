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
    
    let myfilemanager_obj = MyFileManager()
    var files_in_document:[URL] = []
   
    override func viewWillAppear(_ animated: Bool) {
        files_in_document = myfilemanager_obj.getFilesInDocument()
        for file in files_in_document{
            let thisTrack = MusicFile()
            let (songTitle, artist, albumImage) = myfilemanager_obj.getMP3Details(mp3_file: file)
            thisTrack.musicArtist = artist
            thisTrack.musicImage = albumImage
            thisTrack.musicTitle = songTitle
            items.append(thisTrack)
        }
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
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMusic"{
            // preparo il dato
            let vc = segue.destination as! ShowMusicViewController // la casto alla classe di arrivo
            
            let track = sender as! Track
            vc.selectedTrack = track
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        thisView.reloadData()
//    }
    
    
    
}

