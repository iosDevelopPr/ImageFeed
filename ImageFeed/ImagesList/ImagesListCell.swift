//
//  File.swift
//  ImageFeed
//
//  Created by Igor on 03.10.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
}
