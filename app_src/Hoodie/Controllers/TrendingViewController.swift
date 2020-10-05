//
//  TrendingViewController.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//


import UIKit
import FCAlertView
import SwiftMessages


class TrendingViewController: UIViewController {
    
    
    @IBOutlet weak var trendingCategoryCollection: UICollectionView!
    @IBOutlet weak var trendingTable: UITableView!
    
    let service = APIServices()
    
    var genreList = [Genre]()
    
    var playList = [Track]()
    
    var songPlays = [Double]()
    
    
    var selectedGenre:Genre!
    let allTabPlaylistID = 1282483245
    var selectedTabPlaylistID:Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedGenre = Genre(id: 0, name: "All")
        self.selectedTabPlaylistID = allTabPlaylistID
        
        trendingCategoryCollection.delegate = self
        trendingCategoryCollection.dataSource = self
        
        trendingTable.delegate = self
        trendingTable.dataSource = self
        

        trendingTable.rowHeight = UITableView.automaticDimension
        
        trendingCategoryCollection.register(UINib(nibName: "TrendingCategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "trending_category_cell")
        
        trendingTable.register(UINib(nibName: "TrendingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "trending_cell")
        
        service.fetchGenres { (genres) in
            self.genreList = genres.data
            //print(self.genreList)
            DispatchQueue.main.async {
                self.trendingCategoryCollection.reloadData()
                self.trendingCategoryCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
            }
        }
        
        
        service.fetchPlaylist(id: allTabPlaylistID) { (playlist) in
            self.playList = playlist.tracks.data
            
            DispatchQueue.main.async {
                self.trendingTable.reloadData()
            }
        }
    }
    
    
    // You want to download all songs
    @IBAction func didSelectDownloadAllTrendings(_ sender: Any) {
        var config = SwiftMessages.Config()

        config.presentationStyle = .bottom

        config.presentationContext = .window(windowLevel: .statusBar)

        config.duration = .seconds(seconds: 3)
        
        let view = MessageView.viewFromNib(layout: .tabView)

        
        view.configureDropShadow()

        let iconText = ["🎸", "😁", "😶"].randomElement()!
        view.configureContent(title: "Download?", body: "Do you want to download all songs in \(selectedGenre.name) genre?", iconText: iconText)

        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Set my application theme
        view.configureTheme(backgroundColor: applicationTintColor, foregroundColor: UIColor.white)
        
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button?.setTitle("Download", for: .normal)
        
        SwiftMessages.show(config: config, view: view)
        
        view.buttonTapHandler = { _ in
            SwiftMessages.hide()
            // Download selected track
            self.service.fetchPlaylist(id: self.selectedTabPlaylistID) { (playlist) in
                var i = 0
                
                // Show download alert
                DispatchQueue.main.async {showDownloadInProgressAlert()}
                
                // Download all tracks with for loop
                for item in playlist.tracks.data{
                    i+=1
                    
                    DispatchQueue.main.async {
                        MusicDownloader().downloadTrack(url: item.link, trackName: item.title) {
                        }
                    }
                    let toPost = item.getTrackDescription()
                    let thisUserRef = DBRef.child(AuthManager().getCurrentUserID()).child(getTodayDateDay()).child(getTodayDateHourMinute()).childByAutoId()
                    thisUserRef.updateChildValues(toPost)
                    if i == 10{break}   // Limit only 10 tracks
                }
            }
        }
    }
    
    
}

extension TrendingViewController: UICollectionViewDelegate {
    
}

extension TrendingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = trendingCategoryCollection.dequeueReusableCell(withReuseIdentifier: "trending_category_cell", for: indexPath) as! TrendingCategoryCollectionViewCell
        
        cell.categoryName.text = genreList[indexPath.row].name
        return cell
    }
    
    
    // Selezione delle righe tabelle top trending 2019
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var config = SwiftMessages.Config()

        config.presentationStyle = .bottom

        config.presentationContext = .window(windowLevel: .statusBar)

        config.duration = .forever
        config.dimMode = .gray(interactive: true)

        config.interactiveHide = false

        config.preferredStatusBarStyle = .lightContent

        
        let view = MessageView.viewFromNib(layout: .tabView)

        
        view.configureDropShadow()

        let iconText = ["🎸", "😁", "😶"].randomElement()!
        view.configureContent(title: "Download?", body: "Do you want to download selected track?", iconText: iconText)

        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Set my application theme
        view.configureTheme(backgroundColor: applicationTintColor, foregroundColor: UIColor.white)
        
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button?.setTitle("Download", for: .normal)
        
        SwiftMessages.show(config: config, view: view)
        
        // Download Selected song
        view.buttonTapHandler = { _ in
            SwiftMessages.hide()
            self.service.fetchPlaylist(id: self.selectedTabPlaylistID) { (playlist) in
                let downloadableTrackLink = playlist.tracks.data[indexPath.row].link
                let downloadableTrackName = playlist.tracks.data[indexPath.row].title
                let downloadableTrackArtist = playlist.tracks.data[indexPath.row].artist.name
                DispatchQueue.main.async {
                    MusicDownloader().downloadTrack(url: downloadableTrackLink, trackName: downloadableTrackName) {}
                   
                    let toPost = playlist.tracks.data[indexPath.row].getTrackDescription()
                    let thisUserRef = DBRef.child(AuthManager().getCurrentUserID()).child(getTodayDateDay()).child(getTodayDateHourMinute()).childByAutoId()
                    thisUserRef.updateChildValues(toPost)
                }
            }
            
            self.downloadSuccessfullyAlert(trackName: self.playList[indexPath.row].title, artistName: self.playList[indexPath.row].artist.name)
        }
    }
    
    func downloadSuccessfullyAlert(trackName:String, artistName:String){
        // Success message
        let iconText = ["🎸", "😁", "😶"].randomElement()!
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureContent(title: "Download Success", body: "\(trackName) - \(artistName) has been downloaded successfully!", iconText: iconText)
        view.configureTheme(.success)
        view.configureDropShadow()
        
        SwiftMessages.show(view: view)
    }
    
}

extension TrendingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
}

extension TrendingViewController: UITableViewDelegate {
    
    // Selezione genere trending in alto
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         print("selezionato \(genreList[indexPath.row])")
        self.selectedGenre = genreList[indexPath.row]
        service.fetchPlaylistSearch(query: genreList[indexPath.row].name) { (response) in
            
            self.selectedTabPlaylistID = response.data[0].id
            // Populate the table by fetching the first result in search
            self.service.fetchPlaylist(id: self.selectedTabPlaylistID) { (playlist) in
                self.playList = playlist.tracks.data
                
                DispatchQueue.main.async {
                    self.trendingTable.reloadData()
                }
            }
        }
    }
    
}

extension TrendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playList.count > 10 ? 10 : playList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = trendingTable.dequeueReusableCell(withIdentifier: "trending_cell", for: indexPath) as! TrendingTableViewCell
        
        cell.rank.text = "#\(indexPath.row + 1)"
        cell.trackTitle.text = playList[indexPath.row].title
        cell.trackArtist.text = playList[indexPath.row].artist.name
        
        cell.dottedButtons.tag = indexPath.item
        cell.dottedButtons.addTarget(self, action: #selector(self.didSelectDot(_:)), for: .touchUpInside)
        
        playList[indexPath.row].album.cover.downloadImage { (img) in
            DispatchQueue.main.async {
                cell.trackImg.image = img!
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    
    @objc func didSelectDot(_ sender: UIButton){
        let selectedButton = sender
        let items = ["Download"]
        let controller = ArrayChoiceTableViewController(items) { (name) in
            if name == items[0]{
                self.service.fetchPlaylist(id: self.selectedTabPlaylistID) { (playlist) in

                DispatchQueue.main.async {
                    let downloadableTrackLink = playlist.tracks.data[selectedButton.tag].link
                    let downloadableTrackName = playlist.tracks.data[selectedButton.tag].title
                    MusicDownloader().downloadTrack(url: downloadableTrackLink, trackName: downloadableTrackName) {
                    }
                    let toPost = playlist.tracks.data[selectedButton.tag].getTrackDescription()
                    let thisUserRef = DBRef.child(AuthManager().getCurrentUserID()).child(getTodayDateDay()).child(getTodayDateHourMinute()).childByAutoId()
                    thisUserRef.updateChildValues(toPost)
                }
            }
            }
        }
        
        controller.preferredContentSize = CGSize(width: 120, height: 45.0)
        
        showPopup(controller, sourceView: sender)
        
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    

}
