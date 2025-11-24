//
//  ProfileImageServiceFake.swift
//  ImageFeedTests
//
//  Created by Igor on 25.11.2025.
//

@testable import ImageFeed

final class ProfileImageServiceFake: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    init() {
        avatarURL = "https://avatars.githubusercontent.com/u/12345678?v=4"
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
        
    }
}
