//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.01.2025.
//

import Foundation

struct AuthenticatedUser: Decodable {
    let access_token: String
    let refresh_token: String
    let scope: String
    let user_id: Int
    let username: String
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
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
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            return completion(.failure(NetworkError.invalidUrl))
        }
        
        let task = URLSession.shared.data(
            for: request
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(AuthenticatedUser.self, from: data)
                    completion(.success(user.access_token))
                } catch {
                    completion(.failure(NetworkError.unknownError(error)))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        task.resume()
    }
}
