//
//  OAuth2ServiceStorage.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

final class OAuth2ServiceStorage {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case accessToken = "accessToken"
    }
    
    var token: String? {
        get {
            return storage.string(forKey: Keys.accessToken.rawValue)
        } set {
            storage.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
}
