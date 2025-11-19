//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Igor on 11.11.2025.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared: ImagesListService = ImagesListService()
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    
    private let urlSession: URLSession = .shared
    private var task: URLSessionTask?
    
    private let numberImagesPerPage: Int = 10
    
    private init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()

        guard let token = OAuth2ServiceStorage.shared.token,
              let request = makeGetListRequest(token: token) else {
            logger.log("Не удалось создать запрос для изображения профиля")
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResults):
                for photoResult in photoResults {
                    self.photos.append(self.getPhoto(photoResult: photoResult))
                }
                self.lastLoadedPage += 1
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Images": self.photos]
                )
            case .failure(let error):
                logger.log("Ошибка при получении изображений: \(error)")
            }
            self.task = nil
        }
        task?.resume()
    }
    
    private func makeGetListRequest(token: String) -> URLRequest? {
        guard let urlComponents = URLComponents(
            string: Constants.unsplashListURLString + "?page=\(lastLoadedPage + 1)&per_page=\(numberImagesPerPage)") else { return nil }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    private func getPhoto(photoResult: PhotoResult) -> Photo {
        Photo.init(
            id: photoResult.id,
            createdAt: photoResult.createdAt,
            thumbImageURL: photoResult.urls?.thumbImageURL,
            largeImageURL: photoResult.urls?.largeImageURL,
            isLiked: photoResult.isLiked ?? false,
            size: CGSize(width: photoResult.width, height: photoResult.height)
        )
    }
    
    func sendImageLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = OAuth2ServiceStorage.shared.token,
              let request = makeLikePhotoRequest(token: token, photoId: photoId, isLike: isLike) else {
            logger.log("Не удалось создать запрос для изменения лайка")
            return
        }
        
        task = urlSession.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                completion(.success(()))
            case .failure(let error):
                logger.log("Ошибка при изменении лайка: \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        task?.resume()
    }
    
    private func makeLikePhotoRequest(token: String, photoId: String, isLike: Bool) -> URLRequest? {
        guard let urlComponents = URLComponents(
            string: Constants.unsplashListURLString + "/\(photoId)/like") else { return nil }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = !isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        
        return request
    }
}

extension ImagesListService {
    func removeData() {
        task?.cancel()
        task = nil
        
        photos = []
        lastLoadedPage = 0
    }
}
