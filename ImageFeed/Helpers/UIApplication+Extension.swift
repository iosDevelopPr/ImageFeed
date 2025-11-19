//
//  UIApplication+Extension.swift
//  ImageFeed
//
//  Created by Igor on 06.11.2025.
//

import UIKit

extension UIApplication {
    var windows: [UIWindow] {
        connectedScenes
            .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
    }
}
