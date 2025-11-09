//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Igor on 08.11.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    private let ImagesListIdentifier = "ImagesListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: ImagesListIdentifier
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.view.backgroundColor = .ypBlack
        profileViewController.tabBarItem = UITabBarItem(
            title: "", image: UIImage(resource: .tabProfileActive), selectedImage: nil)
        
        viewControllers = [imagesListViewController, profileViewController]
    }
}
