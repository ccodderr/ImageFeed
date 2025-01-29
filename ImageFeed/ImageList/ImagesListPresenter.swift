//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 27.01.2025.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func photosCount() -> Int
    func getImage(for indexPath: IndexPath) -> Photo?
    func loadNewImagesIfNeeded(with indexPath: IndexPath)
    func didTapLike(for indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    var view: (any ImagesListViewControllerProtocol)?
    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var isEnd = false
    private var imagesServiceObserver: NSObjectProtocol?

    func viewDidLoad() {
        imagesServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] value in
                guard let self = self else { return }
                self.updateTableViewAnimated()
                let newImages = value.userInfo?["images"] as? [Photo] ?? []
                self.isEnd = newImages.count == .zero
            }
        
        imagesListService.fetchPhotosNextPage(completion: nil)
    }
    
    deinit {
        guard let imagesServiceObserver else { return }
        NotificationCenter.default.removeObserver(imagesServiceObserver)
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func getImage(for indexPath: IndexPath) -> Photo? {
        guard photos.count - 1 >= indexPath.row else { return nil }
        return photos[indexPath.row]
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            view?.updateTableViewAnimated(indexPaths: indexPaths)
        }
    }
    
    func loadNewImagesIfNeeded(with indexPath: IndexPath) {
        guard indexPath.row + 1 == photosCount(),
              !isEnd
        else { return }
        
        imagesListService.fetchPhotosNextPage(completion: nil)
    }
    
    func didTapLike(for indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        view?.showProgressHUD()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            view?.hideProgressHUD()
            switch result {
            case .success:
                photos = imagesListService.photos
                self.view?.updateCellLike(with: indexPath, value: photos[indexPath.row].isLiked)
            case .failure:
                print("[didTapLike]: Failed to change like status")
                self.view?.presentAlert(with: AlertMessages.likeError)
            }
        }
    }
}
