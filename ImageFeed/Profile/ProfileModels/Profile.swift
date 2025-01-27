//
//  Profile.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 16.01.2025.
//

struct Profile {
    let username: String?
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileDTO) {
        self.username = profileResult.username
        self.name = "\(profileResult.first_name ?? "") \(profileResult.last_name ?? "")"
        self.loginName = "@\(profileResult.username ?? "")"
        self.bio = profileResult.bio
    }
}
