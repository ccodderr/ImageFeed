//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.11.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var picture: UIImageView!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var dateLabel: UILabel!
}
