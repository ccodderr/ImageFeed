//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 15.11.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profileIcon")
        imageView.tintColor = .ypGray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadProfileData()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        updateAvatar()
    }
    
    deinit {
        guard let profileImageServiceObserver else { return }
        NotificationCenter.default.removeObserver(profileImageServiceObserver)
    }
    
    @objc private func didTapButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let logOutAction = UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
        }
        let closeAlertAction = UIAlertAction(title: "Нет", style: .cancel)
        
        [logOutAction, closeAlertAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    private func loadProfileData() {
        guard let profile = profileService.profile else { return }
        
        setProfileData(profile: profile)
    }
    
    private func setProfileData(profile: Profile) {
        nameLabel?.text = profile.name
        loginNameLabel?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profileIcon")
        )
    }
    
    private func setupLayout() {
        view.backgroundColor = .ypBlack
        
        // ImageView
        view.addSubview(avatarImageView)
        
        // Name Label
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 23)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        self.nameLabel = nameLabel
        
        // Login Name Label
        let loginNameLabel = UILabel()
        loginNameLabel.font = .systemFont(ofSize: 13)
        loginNameLabel.textColor = .ypGray
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        self.loginNameLabel = loginNameLabel
        
        // Description Label
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
        
        // Exit Button
        view.addSubview(logOutButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // ImageView Constraints
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // Name Label Constraints
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            // Login Name Label Constraints
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            // Description Label Constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            // Exit Button Constraints
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            logOutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 24),
            logOutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
