//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 15.11.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setProfileData(profile: Profile)
    func updateAvatar(with url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profileIcon")
        imageView.tintColor = .ypGray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .ypGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside
        )
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "signOut"
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    @objc private func didTapButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let logOutAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            ProfileLogoutService.shared.logout()
            self?.dismiss(animated: true)
        }
        let closeAlertAction = UIAlertAction(title: "Нет", style: .cancel)
        
        [logOutAction, closeAlertAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func setProfileData(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar(with url: URL) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profileIcon")
        )
    }
    
    private func setupLayout() {
        view.backgroundColor = .ypBlack
        
        [
            avatarImageView,
            nameLabel,
            loginNameLabel,
            descriptionLabel,
            logOutButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
