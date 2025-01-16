//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.01.2025.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let bearerTokenKey = "bearerTokenKey"
    
    private init() {}
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: bearerTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: bearerTokenKey)
        }
    }
}
