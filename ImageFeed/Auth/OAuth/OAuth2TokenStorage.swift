//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.01.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let bearerTokenKey = "bearerTokenKey"
    
    private init() {}
    
    var token: String? {
        get {
            guard let token = KeychainWrapper.standard.string(forKey: bearerTokenKey) else {
                print("[OAuth2TokenStorage]: Error - Failed to retrieve token from Keychain.")
                return nil
            }
            return token
        }
        set {
            guard let newValue else {
                print("[OAuth2TokenStorage]: Error - Failed to save token to Keychain.")
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: bearerTokenKey)
        }
    }
}

