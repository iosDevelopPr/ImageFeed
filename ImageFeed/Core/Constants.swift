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
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}
