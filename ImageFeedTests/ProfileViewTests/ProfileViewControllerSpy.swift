//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Igor on 25.11.2025.
//

@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfilePresenterProtocol)?
    
    var didUpdateProfileCalled = false
    var didUpdateAvatarCalled = false
    var didShowLogoutAlertCalled = false
    
    func configure(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        didUpdateProfileCalled = true
    }
    
    func updateAvatarDetails(url: URL?) {
        didUpdateAvatarCalled = true
    }
    
    func setupViewUI() {
        
    }
    
    func showLogoutAlert(alertController: UIAlertController?) {
        didShowLogoutAlertCalled = true
    }
    
    
}
