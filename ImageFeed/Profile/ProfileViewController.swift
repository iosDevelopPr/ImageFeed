//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Igor on 07.10.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var AvatarImage: UIImageView!
    @IBOutlet private weak var UserNameLabel: UILabel!
    @IBOutlet private weak var NicNameLabel: UILabel!
    @IBOutlet private weak var MessageLabel: UILabel!
    @IBOutlet private weak var ExitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TODO:
    @IBAction func ExitButtonTap(_ sender: Any) {
    }
}
