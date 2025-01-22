//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.11.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    private var isLiked: Bool = false
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    private lazy var picture: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.backgroundColor = .white.withAlphaComponent(0.5)
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .white.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.text = dateFormatter.string(from: Date())
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
        ) { [tableView] result in
            switch result {
            case .success:
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("[ImageListCell] Failed to load image in cell. Error: \(error.localizedDescription).")
            }
        }
        
        if let date = image.createdAt {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "..."
        }
        setIsLiked(image.isLiked)
    }
    
    @objc private func likeButtonClicked() {
       delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        self.isLiked = isLiked
        button.tintColor = isLiked ? UIColor.ypRed : .white.withAlphaComponent(0.5)
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        [picture, dateLabel, button].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            [
                picture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                picture.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                picture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
                picture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
                
                dateLabel.leadingAnchor.constraint(equalTo: picture.leadingAnchor, constant: 8),
                dateLabel.bottomAnchor.constraint(equalTo: picture.bottomAnchor, constant: -8),
                
                button.widthAnchor.constraint(equalToConstant: 44),
                button.heightAnchor.constraint(equalToConstant: 44),
                button.topAnchor.constraint(equalTo: picture.topAnchor),
                button.trailingAnchor.constraint(equalTo: picture.trailingAnchor)
            ]
        )
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
