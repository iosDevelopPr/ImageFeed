//
//  MockImageListService.swift
//  ImageFeedTests
//
//  Created by Igor on 24.11.2025.
//

@testable import ImageFeed
import Foundation

final class MockImageListService: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var fetchPhotosNextPageCalled: Bool = false
    var chengeLikeCalled: Bool = false
    
    init() {
        photos.append(Photo(id: "1", createdAt: nil, thumbImageURL: "", largeImageURL: "", isLiked: true, size: CGSize(width: 0, height: 0)))
        photos.append(Photo(id: "2", createdAt: nil, thumbImageURL: "", largeImageURL: "", isLiked: true, size: CGSize(width: 0, height: 0)))
        photos.append(Photo(id: "3", createdAt: nil, thumbImageURL: "", largeImageURL: "", isLiked: true, size: CGSize(width: 0, height: 0)))
        photos.append(Photo(id: "4", createdAt: nil, thumbImageURL: "", largeImageURL: "", isLiked: true, size: CGSize(width: 0, height: 0)))
        photos.append(Photo(id: "5", createdAt: nil, thumbImageURL: "", largeImageURL: "", isLiked: true, size: CGSize(width: 0, height: 0)))
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func sendImageLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        chengeLikeCalled = true
        completion(.success(()))
    }
}
