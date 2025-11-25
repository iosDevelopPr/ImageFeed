//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Igor on 22.11.2025.
//

import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var cellHeightCache: [IndexPath: Double] { get set }
    
    func viewDidLoad()
    func showSingleImage(for segue: UIStoryboardSegue, sender: Any?)
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void)
    func getNumberOfRows() -> Int
    func fetchPhotosNextPage(indexPath: IndexPath)
    func configCell(cell: ImagesListCell, for indexPath: IndexPath,
        completion: @escaping (_ isLiked: Bool) -> Void)
    func changeLike(index: Int, completion: @escaping (_ isLiked: Bool) -> Void)
    func getCellHeight(indexPath: IndexPath, width: CGFloat) -> CGFloat
}
