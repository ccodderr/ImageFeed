//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.11.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var picture: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.text = Date().dateTimeString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        picture.kf.cancelDownloadTask()
    }
    
    // MARK: - Methods
    
    func configCell(
        in tableView: UITableView,
        with indexPath: IndexPath,
        image: Photo
    ) {
        let size: CGSize = .init(
            width: tableView.bounds.width,
            height: getHeight(of: image, maxWidth: tableView.bounds.width)
        )
        
        picture.kf.indicatorType = .activity
        picture.kf.setImage(
            with: image.largeImageURL,
            placeholder: UIImage(named: "placeholderImageList"),
            options: [
                .processor(DownsamplingImageProcessor(size: size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("[ImageListCell] Failed to load image in cell. Error: \(error.localizedDescription).")
            }
        }
        
        if indexPath.row % 2 == 0 {
            button.tintColor = .ypRed
        } else {
            button.tintColor = .white.withAlphaComponent(0.5)
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        [picture, dateLabel, button].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            picture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            picture.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            picture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            picture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            dateLabel.leadingAnchor.constraint(equalTo: picture.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: picture.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: picture.trailingAnchor, constant: -8),
            
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.topAnchor.constraint(equalTo: picture.topAnchor),
            button.trailingAnchor.constraint(equalTo: picture.trailingAnchor)
        ])
    }
    
    private func getHeight(of image: Photo, maxWidth: CGFloat) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = maxWidth - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}
