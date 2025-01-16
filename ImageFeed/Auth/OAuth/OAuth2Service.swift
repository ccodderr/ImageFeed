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
            print("Error: failed to create the request")
            return completion(.failure(NetworkError.invalidUrl))
        }
        
        if lastCode != code {
            lastCode = code
        } else {
            completion(.failure(NetworkError.duplicate))
            return
        }
        
        lastTask?.cancel()
        
        lastTask = URLSession.shared.data(
            for: request
        ) { [weak self] result in
            self?.lastCode = nil
            
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(AuthenticatedUser.self, from: data)
                    completion(.success(user.access_token))
                } catch {
                    print("Error: decoding error=\(error)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let failure):
                print("Error: request error=\(failure)")
                completion(.failure(failure))
            }
        }
        
        lastTask?.resume()
    }
}

private extension OAuth2Service {
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Error: failed to create URL")
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
            print("Error: failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
