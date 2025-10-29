//
//  File.swift
//  ImageFeed
//
//  Created by Igor on 03.10.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet public weak var likeButton: UIButton!
    @IBOutlet public weak var cellImage: UIImageView!
    @IBOutlet public weak var dateView: UIView!
    @IBOutlet public weak var dateLabel: UILabel!
}
