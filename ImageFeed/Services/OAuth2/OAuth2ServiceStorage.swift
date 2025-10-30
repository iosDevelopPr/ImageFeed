//
//  OAuth2ServiceStorage.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

final class OAuth2ServiceStorage {
    static let shared: OAuth2ServiceStorage = OAuth2ServiceStorage()
    private let storage: UserDefaults = .standard

    private init() {}
    
    private enum Keys: String {
        case accessToken = "accessToken"
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.accessToken.rawValue)
        } set {
            storage.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
}
