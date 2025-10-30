//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Igor on 27.10.2025.
//

import Foundation

struct NetworkClient {
    private let log: Logging = .log
    
    func fetchData(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        let fulfillHandlerOnMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                log.log(error)
                fulfillHandlerOnMainThread(.failure(error))
                return
            }
            
            guard let resp = response as? HTTPURLResponse else {
                let responsError = NetworkError.invalidRequest
                log.log(responsError)
                fulfillHandlerOnMainThread(.failure(responsError))
                return
            }
            
            guard resp.statusCode >= 200 && resp.statusCode < 300 else {
                let responsError = NetworkError.httpsStatusCode(resp.statusCode)
                log.log(responsError)
                fulfillHandlerOnMainThread(.failure(responsError))
                return
            }
    
            guard let data else {
                let responsError = NetworkError.emptyData
                log.log(responsError)
                fulfillHandlerOnMainThread(.failure(responsError))
                return
            }
            
            fulfillHandlerOnMainThread(.success(data))
        }
        task.resume()
    }
}
