//
//  LibraryViewController.swift
//  Hoodie
//  Created by Luca Tomei on 04/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import PopupDialog
class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    // UICollectionViewDelegateFlowLayout ---->  is for 3 items in one row
    
    @IBOutlet weak var thisView: UICollectionView!
    let reuseIdentifier = "music_cell"
    
    
    let myfilemanager_obj = MyFileManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload),name:NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func shouldReload() {
        DispatchQueue.main.async {
            print("Reloading")
            self.thisView.reloadData()
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
        let selectedTrack = MusicInLocal[indexPath.row]
        
        self.showActionsPopup(selectedTrack: selectedTrack)
        
        
    }
    
    
    func showActionsPopup(selectedTrack:music){
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
        pv.titleColor   = .black
        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
        pv.messageColor = applicationTintColor

//        // Customize the container view appearance
//        let pcv = PopupDialogContainerView.appearance()
//        pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
//        pcv.cornerRadius    = 2
//        pcv.shadowEnabled   = true
//        pcv.shadowColor     = .black

        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.liveBlurEnabled = true
        ov.opacity         = 0.7
        ov.color           = .black

        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        db.titleColor     = .white
        db.buttonColor    = applicationTintColor
        db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)

        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        cb.titleColor     = UIColor(white: 0.8, alpha: 1)
        cb.buttonColor    = applicationTintColor
        cb.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
        
        
        
        // Prepare the popup assets
        let title = "🦄"
        let message = "What do you want to do with \"\(selectedTrack.trackName!.description)\" by \"\(selectedTrack.artistName!.description)\"?"
        let image = UIImage(named: "pexels-photo-103290")

        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        
        // Create buttons
        let buttonOne = DefaultButton(title: "🎵 Play Song 🎵") {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showMusicFromLibrary", sender: selectedTrack)
                self.tabBarController?.selectedIndex = 4
            }
        }
        let buttonTwo = DefaultButton(title: "🗑️ Delete Song 🗑️") {
            DispatchQueue.main.async {
                self.myfilemanager_obj.deleteSong(track: selectedTrack)
                MusicInLocal = self.myfilemanager_obj.getSongsInDocument()
                                    
                self.thisView.reloadData()
            }
        }
        let buttonThree = CancelButton(title: "✖️ Cancel ✖️") {}
        
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMusicFromLibrary"{
            // preparo il dato
            
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

