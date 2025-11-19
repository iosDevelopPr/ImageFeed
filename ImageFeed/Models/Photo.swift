//
//  Photo.swift
//  ImageFeed
//
//  Created by Igor on 11.11.2025.
//

import Foundation

struct Photo {
    let id: String
    let createdAt: Date?
    let thumbImageURL: String?
    let largeImageURL: String?
    var isLiked: Bool
    let size: CGSize
}
