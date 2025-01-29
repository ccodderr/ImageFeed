//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 28.01.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateUserDetails() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.setProfileData(profile: Profile(
                username: "ElonMusk",
                name: "Elon Musk",
                loginName: "@ElonMusk",
                bio: "Changing the world one step at a time"
            )
        )
        
        // then
        XCTAssertTrue(viewController.updateUserDetailsCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        let avatarURL = URL(string: "https://example.com/avatar.jpg")!
        
        // when
        viewController.updateAvatar(with: avatarURL)
        
        // then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testUpdateAvatarCalledMultipleTimes() {
        // given
        let viewController = ProfileViewControllerSpy()
        let avatarURL = URL(string: "https://example.com/avatar.jpg")!
        
        // when
        viewController.updateAvatar(with: avatarURL)
        viewController.updateAvatar(with: avatarURL)
        viewController.updateAvatar(with: avatarURL)
        
        // then
        XCTAssertEqual(viewController.updateAvatarCounter, 3)
    }
}
