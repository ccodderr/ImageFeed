//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 28.01.2025.
//

import ImageFeed
import ObjectiveC
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateUserDetailsCalled: Bool = false
    
    var updateAvatarCalled: Bool = false
    
    var updateAvatarCounter = 0
    
    func setProfileData(profile: Profile) {
        updateUserDetailsCalled = true
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
        updateAvatarCounter += 1
    }
}
