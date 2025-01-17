//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 16.01.2025.
//

struct ProfileImageDTO: Decodable {
    struct ProfileImage: Decodable {
        let small: String
        let medium: String
        let large: String
    }
    
    let profile_image: ProfileImage
}
