//
//  Logger.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

final class Logging {
    static let shared = Logging()
    
    private init() {}
    
    func log(_ message: String) {
        print("[ImageFeed log]: \(message)")
    }
    
    func log(_ error: Error) {
        print("[ImageFeed log]: \(error)")
    }
}
