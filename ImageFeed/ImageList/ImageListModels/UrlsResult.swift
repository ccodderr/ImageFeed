//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 21.01.2025.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
