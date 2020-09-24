//
//  TrendingViewController.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//


import UIKit

class TrendingViewController: UIViewController {
    @IBOutlet weak var trendingCategoryCollection: UICollectionView!
    @IBOutlet weak var trendingTable: UITableView!
    
    let service = APIServices()
    
    var genreList = [Genre]()
    
    var playList = [Track]()
    
    var songPlays = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingCategoryCollection.delegate = self
        trendingCategoryCollection.dataSource = self
        
        trendingTable.delegate = self
        trendingTable.dataSource = self
        

        trendingTable.rowHeight = UITableView.automaticDimension
        
        trendingCategoryCollection.register(UINib(nibName: "TrendingCategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "trending_category_cell")
        
        trendingTable.register(UINib(nibName: "TrendingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "trending_cell")
        
        service.fetchGenres { (genres) in
            self.genreList = genres.data
            print(self.genreList)
            DispatchQueue.main.async {
                self.trendingCategoryCollection.reloadData()
                self.trendingCategoryCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
            }
        }
        
        
        service.fetchPlaylist(id: 7805658222) { (playlist) in
            self.playList = playlist.tracks.data
            
            DispatchQueue.main.async {
                self.trendingTable.reloadData()
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
        print("selezionato \(indexPath.row)")
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
        let selectedGenre = genreList[indexPath.row]
//        print("\n\n\n\n")
//        service.fetchAlbumSearch(query: selectedGenre.name) { (albums) in
//            var albumList = albums.data
//            
//        }
        print("selezionato \(genreList[indexPath.row])")
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
    
    
    
}
