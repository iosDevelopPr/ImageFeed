//
//  Logger.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

final class Logging {
    static var log = Logging()
    private init() {}
    
    func log(_ message: String) {
        DispatchQueue.global().sync {
            print("ImageFeed log: \(message)")
        }
    }
    
    func log(_ error: Error) {
        DispatchQueue.global().sync {
            assertionFailure("ImageFeed log: \(error.localizedDescription)")
        }
    }
}
