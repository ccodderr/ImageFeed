//
//  ImagesListTests.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 28.01.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPhotosCountReturnsZero() {
        // given
        let presenter = ImagesListPresenterSpy()
        
        // when
        let count = presenter.photosCount()
        
        // then
        XCTAssertEqual(count, 0, "photosCount() должен возвращать 0.")
    }
    
    func testGetImageReturnsPhoto() {
        // given
        let presenter = ImagesListPresenterSpy()
        let photo = Photo(
            id: "someId",
            size: CGSize(),
            createdAt: Date(),
            welcomeDescription: "Some information about photo",
            thumbImageURL: URL(string: "https://domain.com/photoThumbnail"),
            largeImageURL: URL(string: "https://domain.com/photo"),
            isLiked: false
        )
        let indexPath = IndexPath(row: 0, section: 0)
        
        presenter.photos = [photo]
        
        XCTAssertEqual(presenter.photosCount(), 1)
        XCTAssertEqual(presenter.getImage(for: indexPath), photo)
        XCTAssertEqual(presenter.getImage(for: indexPath)?.largeImageURL, photo.largeImageURL)
        XCTAssertEqual(presenter.getImage(for: indexPath)?.id, photo.id)
        XCTAssertEqual(presenter.getImage(for: indexPath)?.isLiked, photo.isLiked)
    }
    
    func testLoadNewImagesIfNeeded() {
        let presenter = ImagesListPresenterSpy()
        let photo = Photo(
            id: "someId",
            size: CGSize(),
            createdAt: Date(),
            welcomeDescription: "Some information about photo",
            thumbImageURL: URL(string: "https://domain.com/photoThumbnail"),
            largeImageURL: URL(string:"https://domain.com/photo"),
            isLiked: false
        )
        let indexPath = IndexPath(row: 0, section: 0)

        presenter.photos = [photo]
        presenter.didTapLike(for: indexPath)
        XCTAssertEqual(presenter.photos[indexPath.row].isLiked, true)
    }
}
