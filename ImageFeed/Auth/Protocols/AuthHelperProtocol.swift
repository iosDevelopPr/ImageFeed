//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Igor on 20.11.2025.
//

import Foundation

protocol AuthHelperProtocol {
    var authURLRequest: URLRequest? { get }
    
    func getCode(from url: URL) -> String?
}
