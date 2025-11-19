//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Igor on 13.11.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: Date?
    let isLiked: Bool?
    let width: Int
    let height: Int
    let urls: UrlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id, width, height
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
        case urls
    }
}

