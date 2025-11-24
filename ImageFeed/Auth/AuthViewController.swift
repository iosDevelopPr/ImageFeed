//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Igor on 23.10.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service: OAuth2Service = .shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
            
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .backwardButtonBlack)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .backwardButtonBlack)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ypBlack)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    OAuth2ServiceStorage.shared.token = token
                    self.delegate?.didAuthenticate(self)
                case .failure:
                    self.showAuthErrorAlert()
                    break
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

extension AuthViewController {
    func showAuthErrorAlert() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так :)",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
