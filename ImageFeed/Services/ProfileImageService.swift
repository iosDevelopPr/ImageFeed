//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Igor on 07.11.2025.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private var task: URLSessionTask?
    private let urlSession: URLSession = .shared
    private let logger: Logging = .shared
    private let decoder = JSONDecoder()
    private(set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = OAuth2ServiceStorage.shared.token,
              let request = makeGetUserRequest(token: token, user: username) else {
            logger.log("Не удалось создать запрос для изображения профиля")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small
                completion(.success(userResult.profileImage.small))
                
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self,
                                                userInfo: ["URL": self.avatarURL as Any])
            case .failure(let error):
                self.logger.log("Не удалось получить изображение профиля: \(error)")
                completion(.failure(NetworkError.decodingError(error)))
            }
        }
        task?.resume()
    }
    
    private func makeGetUserRequest(token: String, user: String) -> URLRequest? {
        guard let urlComponents = URLComponents(string: Constants.unsplashUsersURLString + "\(user)") else { return nil }
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}
