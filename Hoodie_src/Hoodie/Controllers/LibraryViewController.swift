//
//  LibraryViewController.swift
//  Hoodie
//
//  Created by Luca Tomei on 04/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    // UICollectionViewDelegateFlowLayout ---->  is for 3 items in one row
    
    @IBOutlet weak var thisView: UICollectionView!
    let reuseIdentifier = "music_cell"
    
    
    let myfilemanager_obj = MyFileManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Long pressure
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload),name:NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func shouldReload() {
        DispatchQueue.main.async {
            print("Reloading")
            self.thisView.reloadData()
        }
    }
    
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {

        if sender.state == UIGestureRecognizer.State.began {

            let touchPoint = sender.location(in: self.thisView)
            if let indexPath = self.thisView.indexPathForItem(at: touchPoint) {

                print("Long pressed row: \(indexPath.row)")
                displayAlertButton(viewController: self, title: "Delete", body: "Do you want to delete \(MusicInLocal[indexPath.row].trackName?.description)" , buttonTitle: "Yes") {
                    //delete song
                    self.myfilemanager_obj.deleteSong(track: MusicInLocal[indexPath.row])
                    MusicInLocal = self.myfilemanager_obj.getSongsInDocument()
                    
                    self.thisView.reloadData()
                }
            }
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        MusicInLocal = myfilemanager_obj.getSongsInDocument()
        self.thisView.reloadData()
    }
    
    
    
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MusicInLocal.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! songCollectionViewCell
        
        let this_cell = MusicInLocal[indexPath.item]
        cell.trackName.text = this_cell.trackName
        
        
        
//        if this_cell.musicImage != UIImage(){
//            cell.icon.image = this_cell.
//            //cell.trackIcon.removeFromSuperview()
//            cell.trackIcon = nil
//        }
        let this_image = fromSongUrlToImage(mp3_file: this_cell.getFileURL()!)
        if this_image != UIImage(){
            cell.icon.image = this_image
            cell.trackIcon = nil
        }
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let selectedTrack = MusicInLocal[indexPath.row]
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showMusicFromLibrary", sender: selectedTrack)
            self.tabBarController?.selectedIndex = 4
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
                MusicPlayerVC.launchedFromLibrary = true
            }
        }
    }
    
    
    
    // We want 3 items in one row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    
    
    
}

