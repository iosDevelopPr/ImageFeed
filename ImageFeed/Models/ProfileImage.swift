//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Igor on 07.11.2025.
//

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String

    private enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}
