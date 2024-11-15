//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 15.11.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var exitButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func exitButtonAction(_ sender: Any) { }
}
