//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Igor on 22.11.2025.
//

import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {

    var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol?
    private let profileImageService: ProfileImageServiceProtocol?
    private let profileLogoutService: ProfileLogoutServiceProtocol?
    
    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
        profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    func viewDidLoad() {
        view?.setupViewUI()
        
        guard let profileDetails = profileService?.profile else { return }
        view?.updateProfileDetails(profile: profileDetails)
    
        setObserver()
        updateAvatar()
    }
    
    func logoutButtonTapped() {
        showAuthErrorAlert()
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService?.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        view?.updateAvatarDetails(url: url)
    }
    
    func showAuthErrorAlert() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Да", style: .default) { _ in
            self.profileLogoutService?.removeData()
        }
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in }

        alertController.addAction(okAction)
        alertController.addAction(noAction)
        
        view?.showLogoutAlert(alertController: alertController)
    }

}
