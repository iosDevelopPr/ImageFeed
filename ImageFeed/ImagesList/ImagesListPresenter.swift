//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Igor on 22.11.2025.
//

import UIKit
import Kingfisher

final class ImagesListPresenter: @MainActor ImagesListPresenterProtocol {

    weak var view: ImagesListViewControllerProtocol?
    var cellHeightCache = [IndexPath: Double]()

    private var photos: [Photo] = []
    private var imagesListService: ImagesListServiceProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    init(imagesListService: ImagesListServiceProtocol? = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    deinit {
        removeObserverForImageList()
    }
    
    func viewDidLoad() {
        addObserverForImageList()
        photos = imagesListService?.photos ?? []
    }
    
    private func addObserverForImageList() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            self?.checkIfNewPhotosWereAdded()
        }
    }
    
    private func removeObserverForImageList() {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func checkIfNewPhotosWereAdded() {
        let oldCount = photos.count
        let newCount = imagesListService?.photos.count ?? 0
        
        if oldCount != newCount {
            photos = imagesListService?.photos ?? []
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }

    func showSingleImage(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ImageListConstants.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            guard let pathPhoto = photos[indexPath.row].largeImageURL,
                  let url = URL(string: pathPhoto) else { return }
            
            view?.showSingleImageViewController(vc: viewController, url: url)
        }
    }
    
    @MainActor func configCell(cell: ImagesListCell, for indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let index = indexPath.row
        let photo = photos[index]
        guard
            let thumbImageURL = photo.thumbImageURL,
            let imageUrl = URL(string: thumbImageURL)
        else { return }
        
        let placeholder = UIImage(resource: .placeholder)
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: placeholder) { _ in
            cell.cellImage.kf.indicatorType = .none
        }

        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        completion(photo.isLiked)
    }

    func getNumberOfRows() -> Int {
        photos.count
    }
    
    func fetchPhotosNextPage(indexPath: IndexPath) {
        if indexPath.row + 1 >= photos.count {
            imagesListService?.fetchPhotosNextPage()
        }
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        UIBlockingProgressHUD.show()
        KingfisherManager.shared.retrieveImage(with: url) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func changeLike(index: Int, completion: @escaping (Bool) -> Void) {
        let photo = photos[index]
        
        UIBlockingProgressHUD.show()
        imagesListService?.sendImageLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.photos[index].isLiked.toggle()
                completion(self.photos[index].isLiked)
            case .failure(let error):
                Logging.shared.log("Error: \(error)")
            }
        }
    }
    
    func getCellHeight(indexPath: IndexPath, width: CGFloat) -> CGFloat {
        if let cacheCellHeight = cellHeightCache[indexPath] {
            return cacheCellHeight
        }

        let photo = photos[indexPath.row]
        let imageWidth = photo.size.width
        let scale = width / imageWidth
        let cellHeight = photo.size.height * scale +
            ImageListConstants.imageInsets.top + ImageListConstants.imageInsets.bottom

        cellHeightCache[indexPath] = cellHeight
        return cellHeight
    }
}
