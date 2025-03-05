//
//  LoginFactory.swift
//  mobileUpGallery
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

enum LoginFactory {
    static func createLoginViewController() -> LoginViewController {
        let coordinator = LoginCoordinator<LoginViewController>()
        let viewModel = LoginViewModel(coordinator: coordinator)
        let viewController = LoginViewController(viewModel: viewModel)
        coordinator.router = viewController
        return viewController
    }
}
