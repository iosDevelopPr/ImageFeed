//
//  OAuth2ServiceStorage.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

//import Foundation
import SwiftKeychainWrapper

final class OAuth2ServiceStorage {
    static let shared: OAuth2ServiceStorage = OAuth2ServiceStorage()
    private init() {}
    
    private enum Keys: String {
        case accessToken = "accessToken"
    }
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.accessToken.rawValue)
        } set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Keys.accessToken.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.accessToken.rawValue)
            }
        }
    }
}
