//
//  InspiredCollectionViewCell.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import UIKit

class InspiredCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        albumImg.layer.cornerRadius = 15
    }

}
