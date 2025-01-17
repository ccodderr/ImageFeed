//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.01.2025.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        guard let token = storage.token else {
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
                    
                    let imageListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTabbarId")
                    imageListViewController.modalPresentationStyle = .fullScreen
                    self?.present(imageListViewController, animated: true, completion: nil)
                case .failure(let error):
                    print("error: \(error)")
                    self?.showAuthErrorAlert()
                }
            }
        }
    }
}

private extension SplashViewController {
    func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось получить данные",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
