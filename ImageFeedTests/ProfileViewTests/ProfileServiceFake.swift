//
//  ProfileServiceFake.swift
//  ImageFeedTests
//
//  Created by Igor on 25.11.2025.
//

@testable import ImageFeed

final class ProfileServiceFake: ProfileServiceProtocol {
    var profile: ImageFeed.Profile?
    
    init() {
        profile = ImageFeed.Profile(username: "", name: "", loginName: "", bio: "")
    }
    
    func fetchProfile(token: String, completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) {
        
    }
}
