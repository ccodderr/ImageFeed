//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.01.2025.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var lastCode: String?
    private var lastTask: URLSessionTask?
    private init() {}
    
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken]: NetworkError - Invalid URL")
            return completion(.failure(NetworkError.invalidUrl))
        }
        
        if lastCode != code {
            lastCode = code
        } else {
            print("[fetchOAuthToken]: NetworkError - Duplicate network request detected")
            completion(.failure(NetworkError.duplicate))
            return
        }
        
        lastTask?.cancel()
        
        lastTask = URLSession.shared.objectTask(
            for: request
        ) { [weak self] (result: Result<AuthenticatedUser, Error>) in
            self?.lastCode = nil
            
            switch result {
            case .success(let user):
                completion(.success(user.access_token))
            case .failure(let failure):
                print("[fetchOAuthToken]: NetworkError - Request error - \(failure)")
                completion(.failure(failure))
            }
        }
        
        lastTask?.resume()
    }
}

private extension OAuth2Service {
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("[makeOAuthTokenRequest]: NetworkError - Failed to create base URL")
            return nil
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&client_secret=\(Constants.secretKey)"
            + "&redirect_uri=\(Constants.redirectURI)"
            + "&code=\(code)"
            + "&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("[makeOAuthTokenRequest]: NetworkError - Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
