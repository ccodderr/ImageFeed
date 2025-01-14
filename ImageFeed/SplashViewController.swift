//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        guard storage.token != nil else {
            let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authNavigationId")
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
            return
        }
        
        let imageListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTabbarId")
        imageListViewController.modalPresentationStyle = .fullScreen
        present(imageListViewController, animated: true, completion: nil)
    }
}
