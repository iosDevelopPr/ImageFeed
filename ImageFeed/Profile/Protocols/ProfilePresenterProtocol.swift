//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Igor on 22.11.2025.
//

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func logoutButtonTapped()
}
