//
//  UserResult.swift
//  ImageFeed
//
//  Created by Igor on 07.11.2025.
//

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
