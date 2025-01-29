//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 28.01.2025.
//

import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    
    var photos: [Photo] = []
    
    var view: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func getImage(for indexPath: IndexPath) -> Photo? {
        guard photos.count - 1 >= indexPath.row else { return nil }
        return photos[indexPath.row]
    }
    
    func loadNewImagesIfNeeded(with indexPath: IndexPath) { }
    
    func didTapLike(for indexPath: IndexPath) {
        guard photos.count - 1 >= indexPath.row else { return }
        photos[indexPath.row].isLiked = !photos[indexPath.row].isLiked
    }
}

