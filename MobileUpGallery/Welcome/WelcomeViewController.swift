//
//  WelcomeViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private let presenter: WelcomePresenterProtocol
    private let customView = WelcomeView()
    
    init(presenter: WelcomePresenterProtocol) {
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

extension WelcomeViewController: WelcomeViewDelegate {
    func loginButtonTapped() {
        presenter.startLogin()
    }
}

