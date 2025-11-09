//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Igor on 05.11.2025.
//

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private let urlSession: URLSession = .shared
    private let logger: Logging = .shared
    private let decoder = JSONDecoder()
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeGetRequest(token: token) else {
            logger.log("Не удалось создать запрос профиля")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    self.profile = self.makeProfile(profileResult: profileResult)
                    
                    if let profile = self.profile {
                        completion(.success(profile))
                    } else {
                        self.logger.log("Получена пустая модель профиля")
                        completion(.failure(NetworkError.emptyData))
                    }
                case .failure(let error):
                    self.logger.log("Ошибка при получении профиля: \(error)")
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
    
    private func makeGetRequest(token: String) -> URLRequest? {
        guard let urlComponents = URLComponents(string: Constants.unsplashProfileURLString) else { return nil }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    private func makeProfile(profileResult: ProfileResult) -> Profile {
        let profile = Profile(
            username: profileResult.username,
            name: "\(profileResult.firstName) \(profileResult.lastName)"
                .trimmingCharacters(in: .whitespaces),
            loginName: "@\(profileResult.username)",
            bio: profileResult.bio)
        return profile
    }
}
