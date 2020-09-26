//
//  RecommendedCollectionViewCell.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        albumImg.layer.cornerRadius = 15
    }

}
