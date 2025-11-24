//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Igor on 24.11.2025.
//

public protocol ProfileServiceProtocol: AnyObject {
    var profile: Profile? { get }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}
