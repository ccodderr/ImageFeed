//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 28.01.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var updateCellLikeCalled = false
    var presentAlertCalled = false

    func updateTableViewAnimated(indexPaths: [IndexPath]) {
        updateTableViewAnimatedCalled = true
    }

    func updateCellLike(with indexPath: IndexPath, value: Bool) {
        updateCellLikeCalled = true
    }

    func presentAlert(with error: Error) {
        presentAlertCalled = true
    }
    
    func showProgressHUD() {}
    
    func hideProgressHUD() {}
}
