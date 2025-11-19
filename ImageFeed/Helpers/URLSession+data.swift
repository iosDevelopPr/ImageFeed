//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import Foundation

enum NetworkError: Error {
    case httpsStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
    case emptyData
}

extension URLSession {
    private static let decoder = JSONDecoder()
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data, let response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpsStatusCode(statusCode)))
                }
            } else if let error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        if T.self == OAuthTokenResponseBody.self {
            URLSession.decoder.dateDecodingStrategy = .secondsSince1970
        } else {
            URLSession.decoder.dateDecodingStrategy = .iso8601
        }
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decodedObject = try URLSession.decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    logger.log("Failed to decode data to \(T.self): \(error)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
