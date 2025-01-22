//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 16.01.2025.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func loadProfile(
        with token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                completion(.success(profile))
            case .failure(let failure):
                print("[loadProfile]: Failure - \(failure.localizedDescription)")
                completion(.failure(failure))
            }
        }
    }
}

private extension ProfileService {
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        if task != nil {
            print("[fetchProfile]: Request already in progress")
            completion(.failure(ProfileError.requestInProgress))
            return
        }
        
        guard let request = makeUsersProfileRequest(authToken: token) else {
            print("[fetchProfile]: InvalidRequestError - failed to create URL")
            return completion(.failure(ProfileError.invalidRequest))
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileDTO, Error>) in
            self?.task = nil

            switch result {
            case .success(let profileDTO):
                let profile = Profile(from: profileDTO)
                completion(.success(profile))
                
            case .failure(let error):
                print("[fetchProfileImageURL]: Request error: \(error)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }

    func makeUsersProfileRequest(authToken: String) -> URLRequest? {
        guard let url = URL(
                string: "/me"
                + "?client_id=\(Constants.accessKey)",
                relativeTo: Constants.defaultBaseURL
            )
        else {
            print("[makeProfileImageRequest]: URLCreationError - Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
