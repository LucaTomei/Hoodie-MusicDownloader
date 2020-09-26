//
//  MainTabBarController.swift
//  MusicDownloader
//
//  Created by Luca Tomei on 01/09/2020.
//  Copyright © 2020 Luca Tomei. All rights reserved.
//


import UIKit

class MainTabBarController: UITabBarController {
    
    let newTabBarView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    override func loadView() {
        super.loadView()
        view.insertSubview(newTabBarView, belowSubview: tabBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNewTabbar()
    }
    
    private func setupNewTabbar() {
        NSLayoutConstraint.activate([
            newTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newTabBarView.topAnchor.constraint(equalTo: tabBar.topAnchor)
        ])
        
        newTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let appearance = UITabBar.appearance()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        appearance.barTintColor = .clear
    }
    
    
}
