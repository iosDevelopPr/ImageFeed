//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Igor on 28.10.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let AuthViewIdentifier = "AuthViewController"
    private let TabBarIdentifier = "TabBarViewController"

    private let oauthStorage: OAuth2ServiceStorage = .shared
    private let profileService: ProfileService = .shared
    private let logger: Logging = .shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
        
        if let token = oauthStorage.token {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }

    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: TabBarIdentifier)
        
        window.rootViewController = tabBarController
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        let splashScreen = UIImage(resource: .splashScreen)
        let splashScreenView = UIImageView(image: splashScreen)
        splashScreenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashScreenView)
        
        NSLayoutConstraint.activate([
            splashScreenView.centerXAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            splashScreenView.centerYAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
        ])
    }
    
    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController,
            let authViewController = navigationController.topViewController as? AuthViewController
        else {
            assertionFailure("Invalid view controllers in storyboard")
            return
        }
        authViewController.delegate = self
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oauthStorage.token else { return }
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self?.switchToTabBarController()
            case .failure(let error):
                self?.logger.log("Failed to fetch profile: \(error)")
                break
            }
        }
    }
}
