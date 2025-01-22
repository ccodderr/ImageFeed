//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 21.01.2025.
//

import Foundation

final class ImagesListService {
    // MARK: - Properties
    private(set) var photos: [Photo] = []
    private var lastLoadedPage = 0
    private var isLoading = false
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let shared = ImagesListService()
    private init() {}
    
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage(
        completion: ((Result<[Photo], Error>) -> Void)?
    ) {
        assert(Thread.isMainThread)
        guard
            let token = OAuth2TokenStorage.shared.token
        else { return }
        
        if task != nil {
            print("[ImagesListService] Request already in progress")
            completion?(.failure(ImagesListServiceError.requestInProgress))
            return
        }
        let nextPage = lastLoadedPage + 1
        
        guard let request = makePhotosRequest(token, page: nextPage) else {
            print("[ImagesListService] InvalidRequestError - Failed to create the request")
            completion?(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoDTO], Error>) in
            guard let self else { return }
            self.task = nil
            
            switch result {
            case .success(let photosDTO):
                lastLoadedPage += 1
                
                photosDTO.forEach { photoDTO in
                    let photo = Photo(
                        id: photoDTO.id,
                        size: .init(width: photoDTO.width, height: photoDTO.height),
                        createdAt: self.dateFormatter.date(from: photoDTO.created_at ?? ""),
                        welcomeDescription: photoDTO.description,
                        thumbImageURL: URL(string: photoDTO.urls.thumb),
                        largeImageURL: URL(string: photoDTO.urls.full),
                        isLiked: photoDTO.liked_by_user
                    )
                    
                    self.photos.append(photo)
                }
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["images": photos]
                    )
                
                completion?(.success(photos))
            case .failure(let error):
                print("[fetchProfileImageURL]: Request error: \(error)")
                completion?(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makePhotosRequest(_ token: String, page: Int) -> URLRequest? {
        guard
            let url = URL(
                string: "/photos?page=\(page)",
                relativeTo: Constants.defaultBaseURL
            )
        else {
            print("[makeProfileImageRequest]: URLCreationError - Failed to create URL with page: \(page)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

