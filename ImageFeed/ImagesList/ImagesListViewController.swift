//
//  ViewController.swift
//  ImageFeed
//
//  Created by Igor on 02.10.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    internal var presenter: ImagesListPresenterProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter?.showSingleImage(for: segue, sender: sender)
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListConstants.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        configCell(for: imageListCell, with: indexPath)
        initGradientView(cell: imageListCell)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ImageListConstants.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewWidth = tableView.bounds.width -
            ImageListConstants.imageInsets.left - ImageListConstants.imageInsets.right
        return presenter?.getCellHeight(indexPath: indexPath, width: imageViewWidth) ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosNextPage(indexPath: indexPath)
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        presenter?.configCell(cell: cell, for: indexPath) { isLiked in
            cell.setImageLikeButton(isLiked: isLiked)
        }
        cell.delegate = self
    }
    
    private func initGradientView(cell: ImagesListCell) {
        let contentView = cell.subviews[0]
        
        guard
            let subview = contentView.subviews.first(
                where: { $0.accessibilityIdentifier == ImageListConstants.dateViewIdentifier }
            ),
            subview.layer.sublayers?.first(
                where: { $0.name == ImageListConstants.gradientViewName }
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
        
        gradientView.name = ImageListConstants.gradientViewName
        
        return gradientView
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func likeDidTap(cell: ImagesListCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        
        presenter?.changeLike(index: index) { result in
            cell.setImageLikeButton(isLiked: result)
        }
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func showSingleImageViewController(vc: SingleImageViewController, url: URL) {
        UIBlockingProgressHUD.show()
        presenter?.loadImage(url: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let result else {
                Logging.shared.log("Не удалось загрузить изображение для SingleImageViewController")
                
                let alert = UIAlertController(title: "Ошибка",
                    message: "Не удалось загрузить изображение. Попробовать ещё раз?", preferredStyle: .alert)
                
                let action1 = UIAlertAction(title: "Да", style: .default) { _ in
                    self?.showSingleImageViewController(vc: vc, url: url)
                }
                let action2 = UIAlertAction(title: "Нет", style: .cancel) { _ in
                    vc.dismiss(animated: true, completion: nil)
                }

                alert.addAction(action1)
                alert.addAction(action2)

                vc.present(alert, animated: true)
                return
            }
            vc.image = result
        }
    }
    
    func configure(presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
}
