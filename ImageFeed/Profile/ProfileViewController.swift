//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Igor on 07.10.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let exitButton = UIButton()
    
    private var profileImage: UIImage?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }
    
    @objc private func didTapExitButton(_ sender: Any) {
        presenter?.logoutButtonTapped()
    }
    
    private func setupProfileImage() {
        profileImage = UIImage(resource: .profileOn)
        profileImageView.image = profileImage

        profileImageView.tintColor = .gray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 35
        profileImageView.layer.masksToBounds = true
        
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor(resource: .ypWhite)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupLoginLabel() {
        loginLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginLabel.textColor = UIColor(resource: .ypGray)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginLabel)
        
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(resource: .ypWhite)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupExitButton() {
        let exitImage = UIImage(resource: .exitButton)
        exitButton.setImage(exitImage, for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton(_:)), for: .touchUpInside)
        
        exitButton.accessibilityIdentifier = "logoutButton"
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45)
        ])
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func configure(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func setupViewUI() {
        setupProfileImage()
        setupNameLabel()
        setupLoginLabel()
        setupDescriptionLabel()
        setupExitButton()
    }
    
    func showLogoutAlert(alertController: UIAlertController?) {
        guard let alertController else { return }
        present(alertController, animated: true)
    }
    
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatarDetails(url: URL?) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        profileImageView.kf.setImage(with: url, placeholder: profileImage, options: [.processor(processor)])
    }
}
