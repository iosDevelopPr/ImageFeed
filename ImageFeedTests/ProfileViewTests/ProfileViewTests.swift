//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Igor on 24.11.2025.
//

@testable import ImageFeed
import XCTest

@MainActor
final class ProfileViewTests: XCTestCase {
    
    func testViewControllerDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter: presenter)
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.didViewDidLoadCalled)
    }
    
    func testPresenterViewDidLoad() {
        let viewController = ProfileViewControllerSpy()
        let profileServiceFake = ProfileServiceFake()
        let profileImageServiceFake = ProfileImageServiceFake()
        let presenter = ProfilePresenter(
            profileService: profileServiceFake,
            profileImageService: profileImageServiceFake
        )
        
        viewController.configure(presenter: presenter)
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.didUpdateAvatarCalled)
        XCTAssertTrue(viewController.didUpdateProfileCalled)
    }
    
    func testDidPresenterShowAlert() {
        let viewController = ProfileViewControllerSpy()
        let profileServiceFake = ProfileServiceFake()
        
        let presenter = ProfilePresenter(profileService: profileServiceFake)
        viewController.configure(presenter: presenter)
        
        presenter.logoutButtonTapped()
        
        XCTAssertTrue(viewController.didShowLogoutAlertCalled)
    }
}
