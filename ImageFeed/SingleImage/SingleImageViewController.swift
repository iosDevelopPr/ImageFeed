//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Igor on 08.10.2025.
//

import UIKit

public final class SingleImageViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var sharingButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            updateImageView()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        updateImageView()
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSharingButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        share.popoverPresentationController?.sourceView = self.view
        present(share, animated: true, completion: nil)
    }
    
    private func updateImageView() {
        guard let image else { return }
        
        imageView.image = image
        imageView.frame.size = image.size
        imageView.contentMode = .scaleAspectFit
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let imageframeSize = imageView.frame.size
        
        let centerX = max((visibleRectSize.width - imageframeSize.width) / 2, 0)
        let centerY = max((visibleRectSize.height - imageframeSize.height) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(
            top: centerY, left: centerX, bottom: centerY, right: centerX)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let scrollSize = scrollView.bounds.size
        let imageSize = imageView.frame.size
        
        let centerX = max((scrollSize.width - imageSize.width) / 2, 0)
        let centerY = max((scrollSize.height - imageSize.height) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(
            top: centerY, left: centerX, bottom: centerY, right: centerX)
    }
}
