//
//  Constants.swift
//  ImageFeed
//
//  Created by Igor on 24.10.2025.
//

import Foundation

enum Constants {
    static let accessKey = "faKEmrXy3hp4hZUM_UBvr9DTkl3m-DDLow4J1w-uvng"
    static let secretKey = "OxfTUyDm9Oq0e8m8erF6pID8wjLRVsVZ5jTnvmXRxt4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
    
    static let unsplashProfileURLString = "https://api.unsplash.com/me/"
    static let unsplashUsersURLString = "https://api.unsplash.com/users/"
    static let unsplashListURLString = "https://api.unsplash.com/photos"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString
        )
    }
}
