//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Igor on 16.11.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    public init() {}
    
    func removeData() {
        ProfileService.shared.removeData()
        ProfileImageService.shared.removeData()
        ImagesListService.shared.removeData()
        OAuth2Service.shared.removeData()
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        
        let splashViewController = SplashViewController()
        let window = UIApplication.shared.windows.first
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
}
