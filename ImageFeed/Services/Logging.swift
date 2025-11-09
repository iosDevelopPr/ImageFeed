//
//  Logger.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

final class Logging {
    static let shared = Logging()
    private let queue = DispatchQueue(label: "ImageFeed.Logging", qos: .utility)
    
    private init() {}
    
    func log(_ message: String) {
        queue.sync {
            print("[ImageFeed log]: \(message)")
        }
    }
    
    func log(_ error: Error) {
        queue.sync {
            print("[ImageFeed log]: \(error)")
        }
    }
}
