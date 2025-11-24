//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Igor on 22.11.2025.
//

import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateProfileDetails(profile: Profile)
    func updateAvatarDetails(url: URL?)
    func setupViewUI()
    func showLogoutAlert(alertController: UIAlertController?)
}
