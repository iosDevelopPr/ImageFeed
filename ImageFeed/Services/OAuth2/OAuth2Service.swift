//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Igor on 27.10.2025.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let networkClient = NetworkClient()
    private let decoder = JSONDecoder()
    private let logging: Logging = .log
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        networkClient.fetchData(request: request) { result in
            switch result {
                case .success(let data):
                do {
                    let jsonData = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(jsonData.accessToken))
                } catch {
                    self.logging.log(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                self.logging.log(error)
                completion(.failure(error))
            }
        }
    }

    func makeOAuthTokenRequest(code: String) -> URLRequest? {
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
