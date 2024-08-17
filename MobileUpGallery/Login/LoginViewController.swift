//
//  LoginViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let presenter: LoginPresenterProtocol
    private let customView = LoginView()
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        customView.delegate = self
        view = customView
    }
    
}

extension LoginViewController: LoginViewDelegate {
    func loginButtonTapped() {
        presenter.startLogin()
    }
}

