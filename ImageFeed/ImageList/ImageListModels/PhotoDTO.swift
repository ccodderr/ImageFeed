//
//  PhotoDTO.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 21.01.2025.
//
import Foundation

struct PhotoWrapper: Decodable {
    let photo: PhotoDTO
}

struct PhotoDTO: Decodable {
    let id: String
    let created_at: String?
    let width: Double
    let height: Double
    let description: String?
    let liked_by_user: Bool
    let urls: UrlsResult
}
