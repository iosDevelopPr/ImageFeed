//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Igor on 25.11.2025.
//

@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var didViewDidLoadCalled = false
    
    func viewDidLoad() {
        didViewDidLoadCalled = true
    }
    
    func logoutButtonTapped() {
        
    }
}
