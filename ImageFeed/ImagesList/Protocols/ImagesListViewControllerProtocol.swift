//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Igor on 22.11.2025.
//

import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showSingleImageViewController(vc: SingleImageViewController, url: URL)
}
