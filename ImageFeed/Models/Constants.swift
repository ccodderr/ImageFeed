//
//  Constants.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 10.01.2025.
//

import Foundation

enum Constants {
    static let accessKey = "lMOd6Lql1GFDkCOwKWvvUY8vrhhAXll3BSLVWy0S1pU"
    static let secretKey = "YWqT4UJ57yt0lYcn5fVqGm2Tm5WxIFzdHnR3-wLWOgA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
}

