//
//  AuthenticatedUser.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 16.01.2025.
//

struct AuthenticatedUser: Decodable {
    let access_token: String
    let refresh_token: String
    let scope: String
    let user_id: Int
    let username: String
}
