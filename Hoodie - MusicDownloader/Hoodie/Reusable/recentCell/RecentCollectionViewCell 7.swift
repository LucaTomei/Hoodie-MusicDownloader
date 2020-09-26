//
//  RecentCollectionViewCell.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImg.layer.cornerRadius = 15
    }

}
