//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Igor on 27.10.2025.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let decoder = JSONDecoder()
    private let urlSession: URLSession = .shared
    private let logger: Logging = .shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        task?.cancel()
        
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let jsonData):
                    completion(.success(jsonData.accessToken))
                case .failure(let error):
                    self.logger.log("Failed to fetch OAuth token: \(error)")
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURLString) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        return request
    }

    func makeOAuthViewRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}
