//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Igor on 13.11.2025.
//

import Foundation

struct UrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "small"    // Сделано сознательно - ошибкой не является!
        case largeImageURL = "full"
    }
}
