//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Igor on 24.11.2025.
//

public protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}
