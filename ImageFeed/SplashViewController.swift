//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.01.2025.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "LaunchScreen")
        return imageView
    }()
    
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let token = storage.token, !token.isEmpty else {
            let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authNavigationId")
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
            return
        }
        
        UIBlockingProgressHUD.show()
        profileService.loadProfile(with: token) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()

                switch result {
                case .success(let profile):
                    ProfileImageService.shared.fetchProfileImage(
                        username: profile.username,
                        nil
                    )
                    
                    let tabBarController = TabBarController()
                    tabBarController.modalPresentationStyle = .fullScreen
                    tabBarController.tabBar.backgroundColor = .ypBlack
                    self?.present(tabBarController, animated: true)
                case .failure(let error):
                    print("[SplashViewController]: ProfileError - \(error.localizedDescription)")
                    self?.showErrorAlert(error: AlertMessages.unknownError)
                }
            }
        }
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.backgroundColor = UIColor.ypBlack
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.heightAnchor.constraint(equalToConstant: 77.68),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
