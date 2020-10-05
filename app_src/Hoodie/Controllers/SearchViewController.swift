//
//  SearchViewController.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import UIKit
import SwiftMessages


class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var albumsCollection: UICollectionView!
    
    @IBOutlet weak var showAllBtn: UIButton!
    
    //0641434910
    var selectedRowIndex = -1
    
    
    let service = APIServices()
    
    var searchList = [Track]()
    
    var albumList = [AlbumSearchObject]()
    
    let MusicDL = MusicDownloader()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        
        dismissKeyboardOnTap(view: self.view)
        
        tracksTable.delegate = self
        tracksTable.dataSource = self
        
        albumsCollection.delegate = self
        albumsCollection.dataSource = self
        
        tracksTable.register(UINib(nibName: "SearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "search_cell")
        albumsCollection.register(UINib(nibName: "SearchAlbumCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "album_search_cell")
        
        searchField.layer.cornerRadius = 27
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 47, height: 54))
        
        let searchIcon = UIImageView(image: UIImage(named: "search-icon"))
        searchIcon.frame = CGRect(x: leftView.center.x - 8.5, y: leftView.center.y - 12, width: searchIcon.frame.width, height: searchIcon.frame.height)
        
        leftView.addSubview(searchIcon)
        
        
        searchField.leftViewMode = .always
        searchField.leftView = leftView
        searchField.leftView?.contentMode = .center
        
        resultsView.alpha = searchField.text == "" ? 0 : 1
        
        // Hide show all button
        showAllBtn.isHidden = true
    }
    
    // When ENTER (Invio) is pressed close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }

    
    func search(query: String) {
        
        service.fetchSearch(query: query) { (playlist) in
            self.searchList = playlist.data
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tracksTable.reloadData()
            }
        }
        service.fetchAlbumSearch(query: query) { (albums) in
            self.albumList = albums.data
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.albumsCollection.reloadData()
            }
        }
    }
    @IBAction func textDidChange(_ sender: UITextField) {
        
        if searchField.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.resultsView.alpha = 0
            }
        } else {
            search(query: sender.text!)
            UIView.animate(withDuration: 0.3) {
                self.resultsView.alpha = 1
            }
        }
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count > 3 ? 3 : searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tracksTable.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as! SearchTableViewCell
                cell.trackName.text = searchList[indexPath.row].title
        cell.trackArtist.text = searchList[indexPath.row].artist.name
        
        searchList[indexPath.row].album.cover.downloadImage { (img) in
            DispatchQueue.main.async {
                cell.trackImg.image = img!
            }
        }
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count > 10 ? 10 : albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = albumsCollection.dequeueReusableCell(withReuseIdentifier: "album_search_cell", for: indexPath) as! SearchAlbumCollectionViewCell
        
        cell.albumTitle.text = albumList[indexPath.row].title
        cell.albumArtist.text = albumList[indexPath.row].artist.name

        albumList[indexPath.row].cover.downloadImage { (img) in
            DispatchQueue.main.async {
                cell.albumImg.image = img!
            }
        }    
        return cell
    }
    
    // Download album in search view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAlbum = albumList[indexPath.row]
        print("Selezionato album \(selectedAlbum)")
        
        displayAlertButton(viewController: self, title: "Download?", body: "Do you want to download \"\(selectedAlbum.title)\" Album?", buttonTitle: "YES") {
            
            self.service.fetchAlbum(id: selectedAlbum.id) { (album) in
                for track in album.tracks.data{
                    let downloaded_track = self.MusicDL.downloadTrack(url: track.link.absoluteString, trackName: track.title) {
                        // Single track in album has been downloaded
                    }
                    
                }
            }
            
            let view = MessageView.viewFromNib(layout: .statusLine)
            view.configureTheme(.success)
            view.configureDropShadow()
            let iconText = ["🎉"].randomElement()!

            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

            view.configureContent(title: "Download in Progress", body: "", iconText: iconText)
            view.bodyLabel?.text = "\(selectedAlbum.title) will be downloaded soon!"
            SwiftMessages.show(view: view)
        }
    }
}



// Per la search history
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 232)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    // selezione campi ricerca
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrack = searchList[indexPath.row]
        
        print(selectedTrack.link)
        let downloaded_file_path = MusicDL.downloadTrack(url: selectedTrack.link, trackName: selectedTrack.title) {
            
            DispatchQueue.main.async {
                let toPost = selectedTrack.getTrackDescription()
                let thisUserRef = DBRef.child(AuthManager().getCurrentUserID()).child(getTodayDateDay()).child(getTodayDateHourMinute()).childByAutoId()
                thisUserRef.updateChildValues(toPost)
                
                self.performSegue(withIdentifier: "showPlayer", sender: selectedTrack)
                //self.tabBarController?.selectedIndex = 4
            }
            
        }
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayer"{
            if let MusicPlayerVC = segue.destination as? ShowMusicViewController{
                let track = sender as! Track
                let this_idx = fromTitleArtistToIdx(title: track.title, artist: track.artist.name)

                MusicPlayerVC.SongPlaying = MusicInLocal[this_idx]
                MusicPlayerVC.Songs = MusicInLocal
            }
        }
    }
    
    
}
