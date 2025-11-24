//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Igor on 20.11.2025.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
