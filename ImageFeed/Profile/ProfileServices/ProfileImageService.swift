//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 16.01.2025.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    func fetchProfileImage(
        username: String,
        _ completion: ((Result<Void, Error>) -> Void)?
    ) {
        fetchProfileImageURL(username: username) { [weak self] result in
            switch result {
            case .success(let url):
                self?.avatarURL = url
                completion?(.success(()))
            case .failure(let failure):
                completion?(.failure(failure))
            }
        }
    }
}

private extension ProfileImageService {
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if task != nil {
            print("Request already in progress")
            completion(.failure(ProfileError.requestInProgress))
            return
        }
        
        guard
            let request = makeProfileImageRequest(username: username)
        else {
            print("Error: failed to create URL")
            completion(.failure(ProfileError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(
            for: request
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let profileImage = try JSONDecoder().decode(ProfileImageDTO.self, from: data)
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImage]
                        )
                    completion(.success(profileImage.profile_image.small))
                } catch {
                    print("error decoding=\(error)")
                    completion(.failure(ProfileError.decodingError))
                }
            case .failure(let error):
                
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    func makeProfileImageRequest(username: String) -> URLRequest? {
        guard
            let token = OAuth2TokenStorage.shared.token
        else { return nil }
        
        guard
            let url = URL(
                string: "/users/\(username)"
                + "?client_id=\(Constants.accessKey)",
                relativeTo: Constants.defaultBaseURL
            )
        else {
            print("Error: failed to create URL for username: \(username)")
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
