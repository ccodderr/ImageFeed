//
//  Photo.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 21.01.2025.
//

import Foundation

struct Photo: Equatable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: URL?
    let largeImageURL: URL?
    var isLiked: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
