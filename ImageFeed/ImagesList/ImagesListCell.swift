//
//  File.swift
//  ImageFeed
//
//  Created by Igor on 03.10.2025.
//

import UIKit
import Kingfisher

public final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    func configCell(url: URL, date: Date?) {
        likeButton.accessibilityIdentifier = "likeButton"
        
        let placeholder = UIImage(resource: .placeholder)

        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: placeholder) { _ in
            self.cellImage.kf.indicatorType = .none
        }
        
        dateLabel.text = dateFormatter.string(from: date ?? Date())
    }
    
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
