//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Date
}
