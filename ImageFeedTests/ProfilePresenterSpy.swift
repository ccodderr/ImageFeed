//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 28.01.2025.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
