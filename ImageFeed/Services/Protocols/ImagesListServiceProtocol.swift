//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Igor on 23.11.2025.
//

public protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    
    func fetchPhotosNextPage()
    func sendImageLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}
