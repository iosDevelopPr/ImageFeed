//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Igor on 07.10.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let exitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupProfileImage()
        SetupNameLabel()
        SetupLoginLabel()
        SetupDescriptionLabel()
        SetupExitButton()
    }
    
    // TODO:
    @objc private func didTapExitButton(_ sender: Any) {
    }
    
    private func SetupProfileImage() {
        
        let profileImage = UIImage(named: "profile_on")
        profileImageView.image = profileImage

        profileImageView.tintColor = .gray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func SetupNameLabel() {
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func SetupLoginLabel() {
        
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginLabel)
        
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func SetupDescriptionLabel() {
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func SetupExitButton() {
        
        let exitImage = UIImage(named: "exit_button")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton(_:)), for: .touchUpInside)
        
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
