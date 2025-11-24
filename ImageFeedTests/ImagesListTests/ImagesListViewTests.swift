//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Igor on 23.11.2025.
//

@testable import ImageFeed
import XCTest

@MainActor
final class ImagesListViewTests: XCTestCase {
    
    func testViewControllerViewDidAppear() {
        let mockService = MockImageListService()
        let presenter: ImagesListPresenterProtocol = ImagesListPresenter(imagesListService: mockService)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        
        XCTAssertTrue(viewController != nil)
        
        viewController?.configure(presenter: presenter)
        _ = viewController?.viewDidAppear(true)
        
        XCTAssertEqual(presenter.getNumberOfRows(), 5)
    }
    
    func testFetchPhotosNextPage() {
        let mockService = MockImageListService()
        let presenter = ImagesListPresenter(imagesListService: mockService)
        let indexPath = IndexPath(row: -1, section: 0)
        
        presenter.fetchPhotosNextPage(indexPath: indexPath)
        
        XCTAssertTrue(mockService.fetchPhotosNextPageCalled)
    }
    
    func testToggleLikeState() {
        let mockService = MockImageListService()
        let presenter = ImagesListPresenter(imagesListService: mockService)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let expectation = XCTestExpectation(description: "Like state")
        
        presenter.viewDidLoad()
        
        presenter.changeLike(index: indexPath.row, ) { state in
            XCTAssertEqual(state, false)
            XCTAssertTrue(mockService.chengeLikeCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
