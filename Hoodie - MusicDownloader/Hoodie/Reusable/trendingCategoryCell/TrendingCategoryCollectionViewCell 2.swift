//
//  TrendingCategoryCollectionViewCell.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//


import UIKit

class TrendingCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                categoryName.textColor = UIColor.white
            } else {
                categoryName.textColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 15
        
        let normalView = UIView(frame: bounds)
        normalView.backgroundColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.1)
        self.backgroundView = normalView
        
        let selectedView = UIView(frame: bounds)
        selectedView.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        self.selectedBackgroundView = selectedView
    }

}
