//
//  ViewController.swift
//  ImageFeed
//
//  Created by Igor on 02.10.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let dateViewIdentifier = "dateView"
    private let gradientViewName = "gradientView"
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService: ImagesListService = .shared
    
    private var photos: [Photo] = []
    private var cellHeightCache = [IndexPath: Double]()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            guard let pathPhoto = photos[indexPath.row].largeImageURL,
                  let url = URL(string: pathPhoto) else { return }
            
            loadImages(url: url) { image in
                if image == nil { return }
                viewController.image = image
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newCount = imagesListService.photos.count
        
        if oldCount != newCount {
            photos = imagesListService.photos
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        configCell(for: imageListCell, with: indexPath)
        initGradientView(cell: imageListCell)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cacheCellHeight = cellHeightCache[indexPath] {
            return cacheCellHeight
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right

        let photo = photos[indexPath.row]
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom

        cellHeightCache[indexPath] = cellHeight
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 >= imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard
            let thumbImageURL = photos[indexPath.row].thumbImageURL,
            let imageUrl = URL(string: thumbImageURL)
        else { return }
        
        let placeholder = UIImage(resource: .placeholder)
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: placeholder) { _ in
            cell.cellImage.kf.indicatorType = .none
        }

        if let date = photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        
        let likeImage = photos[indexPath.row].isLiked ? UIImage(resource: .likeButtonOn) : UIImage(resource: .likeButtonOff)
        cell.likeButton.setImage(likeImage, for: .normal)
        
        cell.delegate = self
    }
    
    private func initGradientView(cell: ImagesListCell) {
        let contentView = cell.subviews[0]
        
        guard
            let subview = contentView.subviews.first(
                where: { $0.accessibilityIdentifier == dateViewIdentifier }
            ),
            subview.layer.sublayers?.first(
                where: { $0.name == gradientViewName }
            ) == nil
        else { return }
        
        subview.layer.cornerRadius = 16
        subview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        subview.layer.masksToBounds = true
        
        let gradientView = createGradientView(size: subview.frame.size)
        subview.layer.addSublayer(gradientView)
    }
    
    private func createGradientView(size: CGSize) -> CAGradientLayer {
        let topColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.03).cgColor
        let bottomColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.35).cgColor
        
        let gradientView = CAGradientLayer()
        
        gradientView.frame.size = size
        gradientView.colors = [topColor, bottomColor]
        gradientView.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientView.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientView.name = gradientViewName
        
        return gradientView
    }
}

extension ImagesListViewController {
    private func loadImages(url: URL, completion: @escaping (UIImage?) -> Void) {
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
}

extension ImagesListViewController: ImagesListCellDelegate {
    func likeDidTap(cell: ImagesListCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        
        let id = photos[index].id
        let isLike = photos[index].isLiked
        
        UIBlockingProgressHUD.show()
        imagesListService.sendImageLike(photoId: id, isLike: isLike) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.photos[index].isLiked.toggle()
                cell.setImageLikeButton(isLiked: self.photos[index].isLiked)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
