//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Igor on 05.11.2025.
//

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username, bio
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
