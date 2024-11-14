//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 06.11.2024.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = "\(indexPath.row)"
        
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        cell.picture?.image = image
        
        let dateString = Date().dateTimeString
        
        cell.dateLabel?.text = dateString
        
        if indexPath.row % 2 == 0 {
            cell.button?.tintColor = .ypRed
        } else {
            cell.button?.tintColor = .white.withAlphaComponent(0.5)
        }
        
        cell.picture.layer.cornerRadius = 16
        cell.picture.layer.masksToBounds = true
        cell.dateLabel.textColor = .white
    }
}

    //MARK: UITableView
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}

