//
//  LoginViewController.swift
//  mobileUpGallery
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

final class LoginViewController: HostingController<LoginView> {
    init(viewModel: LoginViewModel) {
        let loginView = LoginView(viewModel: viewModel)
        super.init(rootView: loginView)
    }
}
