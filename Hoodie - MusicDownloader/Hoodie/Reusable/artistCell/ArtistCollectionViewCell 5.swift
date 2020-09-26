//
//  ArtistCollectionViewCell.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artistPhoto: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        artistPhoto.layer.cornerRadius = 15
    }

}
