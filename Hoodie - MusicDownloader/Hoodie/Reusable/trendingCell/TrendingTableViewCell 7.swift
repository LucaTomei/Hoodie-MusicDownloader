//
//  TrendingTableViewCell.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//


import UIKit

class TrendingTableViewCell: UITableViewCell {
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackArtist: UILabel!
    @IBOutlet weak var playsCount: UILabel!
    @IBOutlet weak var rankBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        trackImg.layer.cornerRadius = 15
        
        rankBG.layer.cornerRadius = 25/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: .zero)
    }
}
