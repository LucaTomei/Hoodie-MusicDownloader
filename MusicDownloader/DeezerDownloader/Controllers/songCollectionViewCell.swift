//
//  songCollectionViewCell.swift
//  DeezerDownloader
//
//  Created by Luca Tomei on 04/09/2020.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit


class songCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trackIcon: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        trackIcon.layer.cornerRadius = 15
    }

}
