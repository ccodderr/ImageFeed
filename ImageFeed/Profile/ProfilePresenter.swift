//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 23.01.2025.
//

import Foundation
import Kingfisher
import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        guard let profile = ProfileService.shared.profile else { return }
        
        view?.setProfileData(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }
        
        updateAvatar()
    }
    
    deinit {
        guard let profileImageServiceObserver else { return }
        NotificationCenter.default.removeObserver(profileImageServiceObserver)
    }
    
     func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
         view?.updateAvatar(with: url)
    }
}
