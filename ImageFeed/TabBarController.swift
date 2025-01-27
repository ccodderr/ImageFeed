//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 20.01.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBar.backgroundColor = .ypBlack
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.presenter = ImagesListPresenter()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "square.stack.fill"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.presenter = ProfilePresenter()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "person.crop.circle.fill"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
