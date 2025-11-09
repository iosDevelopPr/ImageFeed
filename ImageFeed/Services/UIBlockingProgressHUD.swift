//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Igor on 05.11.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return nil
        }
        return window
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
