//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
