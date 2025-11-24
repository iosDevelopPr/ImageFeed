//
//  File.swift
//  ImageFeed
//
//  Created by Igor on 03.10.2025.
//

import UIKit

public final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonDidTap(_ sender: UIButton) {
        delegate?.likeDidTap(cell: self)
    }
    
    func setImageLikeButton(isLiked: Bool) {
        let image = UIImage(resource: isLiked ? .likeButtonOn : .likeButtonOff)
        likeButton.setImage(image, for: .normal)
    }
}
