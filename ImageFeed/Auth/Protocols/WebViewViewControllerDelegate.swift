//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Igor on 24.10.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
