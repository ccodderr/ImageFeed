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
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                completion(.success(()))
            case .failure(let failure):
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
            print("Request already in progress")
            completion(.failure(ProfileError.requestInProgress))
            return
        }
        
        guard let request = makeUsersProfileRequest(authToken: token) else {
            print("Error: failed to create the request")
            return completion(.failure(ProfileError.invalidRequest))
        }
        
        let task = URLSession.shared.data(
            for: request
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let raw = String(data: data, encoding: .utf8)
                    let profileDTO = try JSONDecoder().decode(ProfileDTO.self, from: data)
                    let profile: Profile = .init(from: profileDTO)
                    completion(.success(profile))
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

    func makeUsersProfileRequest(authToken: String) -> URLRequest? {
        guard let url = URL(
                string: "/me"
                + "?client_id=\(Constants.accessKey)",
                relativeTo: Constants.defaultBaseURL
            )
        else {
            print("Error: failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
