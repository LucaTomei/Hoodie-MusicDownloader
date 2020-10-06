//
//  ExploreViewController.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//


import UIKit

class ExploreViewController: UIViewController {
    @IBOutlet weak var recentCollection: UICollectionView!
    @IBOutlet weak var recommendedCollection: UICollectionView!
    @IBOutlet weak var inspiredCollection: UICollectionView!
    @IBOutlet weak var artistsCollection: UICollectionView!
    @IBOutlet weak var genresCollection: UICollectionView!
    
    var playlist: Playlist?
    var recentlyPlayed: [Track]?
    var recommendedAlbums: [Track]?
    
    var inspiredList: Playlist?
    var inspiredAlbums: [Track]?
    
    var artistList = [ArtistInfo]()
    
    var genreList = [Genre]()
    
    let service = APIServices()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recentCollection.delegate = self
        recentCollection.dataSource = self
        recommendedCollection.delegate = self
        recommendedCollection.dataSource = self
        inspiredCollection.delegate = self
        inspiredCollection.dataSource = self
        artistsCollection.delegate = self
        artistsCollection.dataSource = self
        genresCollection.delegate = self
        genresCollection.dataSource = self
        
        recentCollection.showsHorizontalScrollIndicator = false
        recommendedCollection.showsHorizontalScrollIndicator = false
        inspiredCollection.showsHorizontalScrollIndicator = false
        artistsCollection.showsHorizontalScrollIndicator = false
        genresCollection.showsHorizontalScrollIndicator = false
        
        recentCollection.register(UINib(nibName: "RecentCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "recent_cell")
        recommendedCollection.register(UINib(nibName: "RecommendedCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "recommended_cell")
        inspiredCollection.register(UINib(nibName: "InspiredCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "inspired_cell")
        artistsCollection.register(UINib(nibName: "ArtistCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "artist_cell")
        genresCollection.register(UINib(nibName: "GenreCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "genre_cell")
        
        service.fetchPlaylist(id: 7805658222) { (playlist) in
            self.playlist = playlist
            DispatchQueue.main.async {
                var recentList = Set<Int>()
                while recentList.count != 15 {
                    recentList.insert(self.playlist!.tracks.data.randomElement()!.id)
                }
                self.recentlyPlayed = self.playlist!.tracks.data.filter { item in
                    recentList.contains( where: { $0 == item.id } )
                }
                
                self.recentlyPlayed?.shuffle()
                
                var recommendedList = Set<Int>()
                while recommendedList.count != 10 {
                    recommendedList.insert(self.playlist!.tracks.data.randomElement()!.id)
                }
                self.recommendedAlbums = self.playlist!.tracks.data.filter { item in
                    recommendedList.contains( where: { $0 == item.id } )
                }
                
                for (index, track) in self.recentlyPlayed!.enumerated() {
                    self.service.fetchArtist(id: track.artist.id) { (artist) in
                        self.artistList.append(artist)
                        if index == self.recentlyPlayed!.count - 1 {
                            DispatchQueue.main.async {
                                self.artistsCollection.reloadData()
                            }
                        }
                    }
                }
                
                self.recommendedAlbums?.shuffle()
                
                self.recentCollection.reloadData()
                self.recommendedCollection.reloadData()
                
            }
        }
        
        
        service.fetchPlaylist(id: 908622995) { (playlist) in
            self.inspiredList = playlist
            DispatchQueue.main.async {
                var inspired = Set<Int>()
                while inspired.count != 15 {
                    inspired.insert(self.inspiredList!.tracks.data.randomElement()!.id)
                }
                self.inspiredAlbums = self.inspiredList!.tracks.data.filter { item in
                    inspired.contains( where: { $0 == item.id } )
                }
                
                self.inspiredAlbums?.shuffle()
                self.inspiredCollection.reloadData()
            }
        }
        
        service.fetchGenres { (genres) in
            self.genreList = genres.data
            DispatchQueue.main.async {
                self.genresCollection.reloadData()
            }
        }
    }
    
}

extension ExploreViewController: UICollectionViewDelegate {
    
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return recentlyPlayed == nil ? 0 : recentlyPlayed!.count
        } else if collectionView.tag == 1 {
            return recommendedAlbums == nil ? 0 : recommendedAlbums!.count
        } else if collectionView.tag == 2 {
            return inspiredAlbums == nil ? 0 : inspiredAlbums!.count
        } else if collectionView.tag == 3 {
            return artistList.count
        } else if collectionView.tag == 4 {
            return genreList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            let cell = recentCollection.dequeueReusableCell(withReuseIdentifier: "recent_cell", for: indexPath) as! RecentCollectionViewCell
            
            cell.trackTitle.text = recentlyPlayed![indexPath.row].title
            
            recentlyPlayed![indexPath.row].album.cover.downloadImage { (img) in
                DispatchQueue.main.async {
                    cell.trackImg.image = img!
                }
            }
            
            return cell
        }
        
        
        if collectionView.tag == 1 {
            let cell = recommendedCollection.dequeueReusableCell(withReuseIdentifier: "recommended_cell", for: indexPath) as! RecommendedCollectionViewCell
            
            cell.albumTitle.text = recommendedAlbums![indexPath.row].album.title
            cell.albumArtist.text = recommendedAlbums![indexPath.row].artist.name
            recommendedAlbums![indexPath.row].album.cover.downloadImage { (img) in
                DispatchQueue.main.async {
                    cell.albumImg.image = img!
                }
            }
            return cell
        }
        
        
        
        if collectionView.tag == 2 {
            let cell = inspiredCollection.dequeueReusableCell(withReuseIdentifier: "inspired_cell", for: indexPath) as! InspiredCollectionViewCell
            
            cell.albumTitle.text = inspiredAlbums![indexPath.row].album.title
            inspiredAlbums![indexPath.row].album.cover.downloadImage { (img) in
                DispatchQueue.main.async {
                    cell.albumImg.image = img!
                }
            }
            
            return cell
        }
        
        
        
        if collectionView.tag == 3 {
            let cell = artistsCollection.dequeueReusableCell(withReuseIdentifier: "artist_cell", for: indexPath) as! ArtistCollectionViewCell
            
            cell.artistName.text = artistList[indexPath.row].name
            artistList[indexPath.row].img.downloadImage { (img) in
                DispatchQueue.main.async {
                    cell.artistPhoto.image = img!
                }
            }
            
            return cell
        }
        
        if collectionView.tag == 4 {
            let cell = genresCollection.dequeueReusableCell(withReuseIdentifier: "genre_cell", for: indexPath) as! GenreCollectionViewCell
            
            cell.genreName.text = genreList[indexPath.row].name
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 || collectionView.tag == 3 {
            return CGSize(width: 115, height: 140)
        } else if collectionView.tag == 1 {
            return CGSize(width: 180, height: 232)
        } else if collectionView.tag == 2 {
            return CGSize(width: 180, height: 236)
        } else if collectionView.tag == 4 {
            return CGSize(width: 148, height: 70)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 || collectionView.tag == 3 {
            return 13
        } else if collectionView.tag == 4 {
            return 20
        }
        return 15
    }
}
